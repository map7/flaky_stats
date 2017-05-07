# Logfile
#
# Deals with reading failing logs, remove old log files and
# logging the flaky stats

module FlakyStats
  class LogFile

    def read_failing_log(failing_log)
      failed_files = []

      # Read in the file
      file = File.readlines(failing_log)

      # Get lines which begin with rspec
      file.each do |line|
        if line =~ /rspec \.\//
          # Get the file name only
          failed_files << line.partition(/\.\/.*.rb/)[1]
        end
      end

      return failed_files
    end
    
  end
end
