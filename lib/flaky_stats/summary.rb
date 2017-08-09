require_relative "output"
require 'csv'

# Summary
#
# Calculate and display summary information for errors and flaky stats

module FlakyStats
  class Summary
    include Output
    
    def initialize(options)
      @failing_log = options[:failing_log]
      @logfile = options[:logfile]
    end

    def display_error_summary()
      heading "Errors summary"
      system("cat #{@failing_log}")
    end

    def calc_flaky_summary
      sum=Hash.new(0)
      CSV.foreach(@logfile) do |row|
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

    def reject_low_flaky_tests(data)
      data.reject{|k,v| v <= 1}
    end
    
    def order_stats(hash)
      hash.sort_by{|key,value| value}.reverse.to_h
    end
  end
end
