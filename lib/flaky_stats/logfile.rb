# Logfile
#
# Deals with reading failing logs, remove old log files and
# logging the flaky stats

module FlakyStats
  class LogFile
    def initialize(options = {})
      @failing_log = options[:failing_log]
      @logfile = options[:logfile]
    end

    def get_error_info(line)
      information= line.partition(/\.\/.*.rb/)
      filename = information[1]
      lineno = information[2].partition(/:/)[2].to_i
      return {filename: filename, lineno: lineno}
    end
    
    # Read the failing log from our test stack
    def read_failing_log()
      failed_files = []

      # Read in the file
      file = File.readlines(@failing_log)

      # Get lines which begin with rspec
      file.each do |line|
        if line =~ /rspec \.\//
          # Get the file name only
          failed_files << get_error_info(line)
        end
      end

      return failed_files
    end

    # Log flaky stats
    def write_flaky_stats(real_flaky_tests)
      File.open(@logfile, "a") do |log|
        real_flaky_tests.each {|data| log.puts data}
      end
    end
    
  end
end
