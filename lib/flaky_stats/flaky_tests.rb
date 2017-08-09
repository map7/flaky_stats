require_relative 'output'

module FlakyStats
  class FlakyTests
    include Output
    
    def initialize(options = {})
      @logfile = options[:logfile]
    end

    def form_data(failed_file = {})
      return [Time.now,failed_file[:filename],failed_file[:lineno],1].join ","
    end

    # Run each failing test singularly and return a list of flaky tests.
    def run(failed_files = [])
      real_flaky_tests = []
      heading("Rerunning failing tests in single thread")

      # Run all failing tests separately with '--format doc' on the end.
      failed_files.each do |failed_file|
        status = system("rspec --format doc #{failed_file[:filename]}")

        # This is a flaky test only, so record it
        real_flaky_tests << form_data(failed_file) if status == true
      end

      return real_flaky_tests
    end
  end  
end
