require_relative "output"
require 'csv'

# Summary
#
# Calculate and display summary information for errors and flaky stats

module FlakyStats
  class Summary
    include Output
    DEFAULT_ROLLOVER_DAYS = 14
    
    def initialize(options)
      @failing_log = options[:failing_log]
      @flaky_tests_log = options[:flaky_tests_log]
      @failed_files = options[:failed_files] || []
      @real_flaky_tests = options[:real_flaky_tests] || []
    end

    def display_error_summary()
      heading "Errors summary"
      system("cat #{@failing_log}")
    end

    def calc_flaky_summary
      sum=Hash.new(0)
      CSV.foreach(@flaky_tests_log) do |row|
        sum[row[1]]+=row[3].to_i
      end
      return order_stats(sum)
    end

    def display_flaky_summary
      heading "Flaky summary"
      reject_low_flaky_tests(calc_flaky_summary).each do |k,v|
        puts "#{v}\t#{k}"
      end
      puts "\n"
    end

    def display_current_flakies
      heading "Flakies which passed in a single thread"

      @real_flaky_tests.each do |flaky|
        puts "#{flaky.split(",")[1]}:#{flaky.split(",")[2]}"
      end
      puts "\n"
    end

    # failed_files=[{:filename=>"./spec/integration/divisions/edit_divisions_spec.rb", :lineno=>26},...]
    # real_flaky_tests = ["2019-10-24 15:30:45 +1100,./spec/integration/reports/activity_statement_spec.rb,13,1",...]
    def filter_error_files(failed_files, real_flaky_tests)
      real_flaky_tests.each do |flaky|
        failed_files.reject!{|error| error[:filename] == flaky.split(",")[1]}
      end
      return failed_files
    end

    def display_failed_tests
      heading "Failed tests"
      real_errors = filter_error_files(@failed_files, @real_flaky_tests)
      real_errors.each { |file| puts "#{file[:filename]}:#{file[:lineno]}"}
      puts "\n"
    end

    def rollover(days = DEFAULT_ROLLOVER_DAYS)
      lines = File.readlines(@flaky_tests_log)
      lines.reject{|line|
        flaky_date = Time.parse(line.split(",")[0]).to_date
        cutoff = Date.today - days
        flaky_date < cutoff
      }
    end

    def rollover_and_write(options = {})
      days = options[:days] || DEFAULT_ROLLOVER_DAYS
      output = options[:output] || "#{@flaky_tests_log}.tmp"

      File.open(output, "w") {|file|
        rollover(days).each do |flaky|
          file.write flaky  
        end        
      }

      # Overwrite log file.
      `cp #{@flaky_tests_log} #{@flaky_tests_log}.old`
      `cp #{@flaky_tests_log}.tmp #{@flaky_tests_log}`
    end

    def reject_low_flaky_tests(data)
      data.reject{|k,v| v <= 1}
    end
    
    def order_stats(hash)
      hash.sort_by{|key,value| value}.reverse.to_h
    end
  end
end
