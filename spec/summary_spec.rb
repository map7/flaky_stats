require "spec_helper"

RSpec.describe "Summary" do
  before do
    @flaky_tests_log = "#{File.dirname(__FILE__)}/files/flaky_tests.log"
    @summary = FlakyStats::Summary.new(flaky_tests_log: @flaky_tests_log,
                                       failed_files: [
                                         {filename:"./spec/integration/divisions/edit_divisions_spec.rb",
                                          lineno: 26},
                                         {filename:"./spec/integration/divisions/edit_divisions_spec.rb",
                                          lineno: 26},
                                         {filename:"./spec/integration/invoices/edit_invoices_spec.rb",
                                          lineno: 1},
                                       ],
                                       real_flaky_tests: ["2019-10-24 15:30:45 +1100,./spec/integration/invoices/edit_invoices_spec.rb,13,1"])
  end

  describe "#calc_flaky_summary" do 
    it "calculates totals" do
      result = @summary.calc_flaky_summary
      expect(result["./spec/integration/invoices/edit_invoices_spec.rb"]).to eq(5)
    end
  end

  describe "#display_flaky_summary" do 
    it "prints heading 'Flaky summary'" do
      expect{@summary.display_flaky_summary()}.to output(/Flaky summary/).to_stdout
    end
  end

  describe "#display_current_flakies" do 
    it "prints heading 'Flakies which passed in a single thread'" do 
      expect{@summary.display_current_flakies()}.to output(/Flakies which passed in a single thread/).to_stdout
    end

    it "prints the list of flakies files" do
      expect{@summary.display_current_flakies()}.to output(/\.\/spec\/integration\/invoices\/edit_invoices_spec\.rb:13/).to_stdout
    end

    it "doesn't include the date" do 
      expect{@summary.display_current_flakies()}.to_not output(/2019\-10\-24\ 15\:30\:45\ \+1100/).to_stdout
    end
  end

  describe "#filter_error_files" do 
    context "given two error files and one which is flaky" do 
      it "returns everything but the flaky files" do 
        result = @summary.filter_error_files([{filename: "a"}, {filename: "b"}], ["date,a"])
        expect(result).to eq([{filename: "b"}])
      end
    end
  end
  
  describe "#display_failed_tests" do 
    it "prints heading 'Failed tests'" do 
      expect{@summary.display_failed_tests()}.to output(/Failed tests/).to_stdout
    end

    it "prints the list of failed files" do
      expect{@summary.display_failed_tests()}.to output(/\.\/spec\/integration\/divisions\/edit_divisions_spec\.rb/).to_stdout
    end

    it "doesn't print flakies" do
      expect{@summary.display_failed_tests()}.to_not output(/\.\/spec\/integration\/invoices\/edit_invoices_spec\.rb/).to_stdout
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

      expect(File.readlines(@flaky_tests_log).count).to eq(27)
      result = @summary.rollover

      expect(result.count).to eq(16)
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

      expect(File.readlines(@flaky_tests_log).count).to eq(27)
      @summary.rollover_and_write(output: output)
      
      expect(File.readlines(output).count).to eq(16)
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
