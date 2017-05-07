module FlakyStats
  class FlakyTests

    def initialize(options)
      @logfile = options[:logfile]
    end

    def run_flaky_tests(failed_files)
      puts "\n\n"
      puts "-------------------------------------------------------------------"
      puts "Rerunning failing tests in single thread"
      puts "-------------------------------------------------------------------"
      
      delete_failing_log = true

      sleep 10                   # Settle everything down.
      
      File.open(@logfile, "a") do |log|
        # Run all failing tests separately with '--format doc' on the end.
        failed_files.each do |failed_file|
          sleep 2                   # Settle everything down.
          
          status = system("rspec --format doc #{failed_file}")

          delete_failing_log = false if status == false
          
          if status == true
            # This is a flaky test only, so record it
            log.puts "#{Time.now},#{failed_file},1"
          end
        end
      end

      return delete_failing_log
    end
  end  
end
