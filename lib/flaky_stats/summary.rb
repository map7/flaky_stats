# Summary
#
# Calculate and display summary information for errors and flaky stats

module FlakyStats
  class Summary
    def initialize(options)
      @failing_log = options[:failing_log]
      @logfile = options[:logfile]
    end

    def display_error_summary()
      puts "\n\n"
      puts "-------------------------------------------------------------------"
      puts "Errors summary"
      puts "-------------------------------------------------------------------"

      system("cat #{@failing_log}")
    end

    def calc_flaky_summary
      sum=Hash.new(0)
      CSV.foreach(@logfile) do |row|
        sum[row[1]]+=row[3].to_i
      end
      return sum
    end


    
    def display_flaky_summary
      puts "\n\n"
      puts "-------------------------------------------------------------------"
      puts "Flaky summary"
      puts "-------------------------------------------------------------------"

      calc_flaky_summary.each do |k,v|
        puts "#{k} = #{v}" if v > 1
      end
      puts "\n"
    end
  end
end
