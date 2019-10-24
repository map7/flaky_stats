require "spec_helper"

RSpec.describe "LogFile" do

  describe "#read_failing_log" do
    before do 
      @logfile = FlakyStats::LogFile.new(failing_log: "#{File.dirname(__FILE__)}/files/failing_specs.log")
    end
    
    it "returns a list of failing tests" do 
      results = @logfile.read_failing_log()
      expect(results.count).to eq(12)
    end
  end
  
  describe "get_error_info" do
    context "filename with lineno exists" do 
      before do 
        @logfile = FlakyStats::LogFile.new()
        @data = @logfile.get_error_info("rspec ./spec/integration/foo/create_foo_spec.rb:11")
      end
      
      it "gets filename" do
        expect(@data[:filename]).to eq("./spec/integration/foo/create_foo_spec.rb")
      end

      it "gets line number" do
        expect(@data[:lineno]).to eq(11)
      end
    end

    context "filename exists no line number" do 
      before do 
        @logfile = FlakyStats::LogFile.new()
        @data = @logfile.get_error_info("rspec ./spec/integration/foo/create_foo_spec.rb")
      end
      
      it "gets filename" do
        expect(@data[:filename]).to eq("./spec/integration/foo/create_foo_spec.rb")
      end

      it "gets line number" do
        expect(@data[:lineno]).to eq(0)
      end
    end
  end
end
