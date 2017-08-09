module FlakyStats
  class FlakyTests

    def line
      puts "-------------------------------------------------------------------"
    end

    def heading(text)
      puts "\n\n"
      line
      puts text
      line
    end

    def initialize(options = {})
      @logfile = options[:logfile]
    end

    def form_data(failed_file = {})
      return [Time.now,failed_file[:filename],failed_file[:lineno],1].join ","
    end

    # Run each failing test singularly and return a list of flaky tests.
    def run(failed_files)
      real_flaky_tests = []
      heading("Rerunning failing tests in single thread")

      # Run all failing tests separately with '--format doc' on the end.
      failed_files.each do |failed_file|
        # sleep 2                   # Settle everything down.
        status = system("rspec --format doc #{failed_file[:filename]}")

        # This is a flaky test only, so record it
        if status == true
          real_flaky_tests << form_data(failed_file)
        end
      end

      return real_flaky_tests
    end
  end  
end
