require 'csv'

LOGFILE=Rails.root + "log/flaky_tests.log"
FAILING_LOG=Rails.root + "tmp/failing_specs.log"

def read_failing_log
  failed_files = []

  # Read in the file
  file = File.readlines(FAILING_LOG)

  # Get lines which begin with rspec
  file.each do |line|
    if line =~ /rspec \.\//
      # Get the file name only
      failed_files << line.partition(/\.\/.*.rb/)[1]
    end
  end

  return failed_files
end

def run_flaky_tests(failed_files)
  puts "\n\n"
  puts "------------------------------------------------------------------------"
  puts "Rerunning failing tests in single thread"
  puts "------------------------------------------------------------------------"
  
  delete_failing_log = true

  sleep 10                   # Settle everything down.
  
  File.open(LOGFILE, "a") do |log|
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

def display_error_summary
  puts "\n\n"
  puts "------------------------------------------------------------------------"
  puts "Errors summary"
  puts "------------------------------------------------------------------------"

  system("cat #{FAILING_LOG}")
end

def calc_flaky_summary
  sum=Hash.new(0)
  CSV.foreach(LOGFILE) do |row|
    sum[row[1]]+=row[2].to_i
  end
  return sum
end

def display_flaky_summary
  puts "\n\n"
  puts "------------------------------------------------------------------------"
  puts "Flaky summary"
  puts "------------------------------------------------------------------------"

  calc_flaky_summary.each do |k,v|
    puts "#{k} = #{v}" if v > 1
  end
  puts "\n"
end

desc "Rerun failing parallel tests in a single thread"
task :rerun => :environment do  |t|
  if File.exist?(FAILING_LOG)
    delete_failing_log = run_flaky_tests(read_failing_log)
    
    display_error_summary
    display_flaky_summary

    # Remove flaky log if everything passed
    File.delete(FAILING_LOG) if delete_failing_log
  end
end
