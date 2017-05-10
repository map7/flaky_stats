require "spec_helper"

RSpec.describe FlakyStats do
  describe "#form_data" do
    before do 
      Timecop.freeze(Time.now)
    end

    after do 
      Timecop.return
    end
    
    it "includes datetime" do
      flaky_tests = FlakyStats::FlakyTests.new
      expect(flaky_tests.form_data).to eq(Time.now)
    end

    
  end
end
