require "spec_helper"

RSpec.describe "Summary" do
  before do 
    @summary = FlakyStats::Summary.new(logfile: "#{File.dirname(__FILE__)}/files/flaky_tests.log")
  end

  describe "#calc_flaky_summary" do 
    it "calculates totals" do
      result = @summary.calc_flaky_summary
      expect(result["./spec/integration/invoices/edit_invoices_spec.rb"]).to eq(5)
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
