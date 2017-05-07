require 'csv'

LOGFILE=Rails.root + "log/flaky_tests.log"
FAILING_LOG=Rails.root + "tmp/failing_specs.log"

desc "Rerun failing parallel tests in a single thread"
task :flaky_stats => :environment do  |t|
  if File.exist?(FAILING_LOG)

    logfile = FlakyStats::LogFile.new(failing_log: FAILING_LOG)
    failed_files = logfile.read_failing_log()

    tests = FlakyStats::Tests.new(logfile: LOGFILE)
    tests.run_flaky_tests(failed_files)

    summary = FlakyStats::Summary.new(failing_log: FAILING_LOG,
                                      logfile: LOGFILE)
    summary.display_error_summary()
    summary.display_flaky_summary()
  end
end
