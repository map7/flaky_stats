require "spec_helper"
require 'byebug'

RSpec.describe "Summary" do
  before do
    @logfile = "#{File.dirname(__FILE__)}/files/flaky_tests.log"
    @summary = FlakyStats::Summary.new(logfile: @logfile)
  end

  describe "#calc_flaky_summary" do 
    it "calculates totals" do
      result = @summary.calc_flaky_summary
      expect(result["./spec/integration/invoices/edit_invoices_spec.rb"]).to eq(5)
    end
  end

  describe "#rollover" do
    before do
      Timecop.freeze(Time.local(2017, 8, 9, 16, 0, 0))
    end

    after do 
      Timecop.return
    end
    
    it "removes old flaky tests from the logfile" do 
      output = "#{File.dirname(__FILE__)}/files/flaky_tests_output.log"

      expect(File.readlines(@logfile).count).to eq(27)
      result = @summary.rollover

      expect(result.count).to eq(15)
    end
  end

  describe "#rollover_and_write" do 
    before do
      Timecop.freeze(Time.local(2017, 8, 9, 16, 0, 0))
    end

    after do 
      Timecop.return
    end

    it "removes old flaky tests from the logfile" do 
      output = "#{File.dirname(__FILE__)}/files/flaky_tests_output.log"

      expect(File.readlines(@logfile).count).to eq(27)
      @summary.rollover_and_write(output: output)
      
      expect(File.readlines(output).count).to eq(15)
    end
  end
  
  describe "#reject_low_flaky_tests" do 
    it "remove flaky tests which have only happened once" do 
      data = {"file1" => 2, "file2" => 3, "file3" => 1}
      result = @summary.reject_low_flaky_tests(data)
      expect(result.count).to eq(2)
    end
  end

  describe "#order_stats" do 
    it "orders from most to least frequent flaky test" do
      data = {"file1" => 2, "file2" => 3, "file3" => 1}
      result = @summary.order_stats(data)
      expect(result.keys[0]).to eq("file2")
      expect(result.values[0]).to eq(3)
    end
  end
end
