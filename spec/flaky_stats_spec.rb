require "spec_helper"

RSpec.describe FlakyStats do
  describe "#form_data" do
    before do 
      Timecop.freeze(Time.now)
      @flaky_tests = FlakyStats::FlakyTests.new
      @failed_file = {filename: "foo_spec.rb", lineno: "12"}
    end

    after do 
      Timecop.return
    end
    
    it "includes datetime" do
      expect(@flaky_tests.form_data(@failed_file)[0]).to eq(Time.now)
    end

    it "includes filename" do 
      expect(@flaky_tests.form_data(@failed_file)[1]).to eq("foo_spec.rb")
    end
  end
end
