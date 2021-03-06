require "spec_helper"
require 'date'

RSpec.describe FlakyStats do
  before do 
    @flaky_tests = FlakyStats::FlakyTests.new
  end
  
  describe "#form_data" do
    before do
      @time=Time.now
      Timecop.freeze(@time)
      @failed_file = {filename: "foo_spec.rb", lineno: "12"}
    end

    after do 
      Timecop.return
    end
    
    it "includes datetime" do
      format = "%d/%m/%Y %H:%M"
      result = @flaky_tests.form_data(@failed_file).split(",")[0]
      result = Time.parse(result).strftime(format)
      expect(result).to eq(@time.strftime(format))
    end

    it "includes filename" do 
      expect(@flaky_tests.form_data(@failed_file).split(",")[1]).to eq("foo_spec.rb")
    end

    it "includes lineno" do 
      expect(@flaky_tests.form_data(@failed_file).split(",")[2]).to eq("12")
    end
  end

  describe "#run" do
    it "should print a heading on the screen" do 
      expect{@flaky_tests.run()}.to output(/Rerunning failing tests in single thread/).to_stdout
    end
  end

end
