require 'csv'

LOGFILE=Rails.root + "log/flaky_tests.log"
FAILING_LOG=Rails.root + "tmp/failing_specs.log"

desc "Rerun failing parallel tests in a single thread"
task :flaky_stats => :environment do  |t|
  if File.exist?(FAILING_LOG)

    # Read failing log
    logfile = FlakyStats::LogFile.new(failing_log: FAILING_LOG)
    failed_files = logfile.read_failing_log()

    # Run tests singularly
    flaky_tests = FlakyStats::FlakyTests.new(logfile: LOGFILE)
    flaky_tests.run(failed_files)

    # Display summaries
    summary = FlakyStats::Summary.new(failing_log: FAILING_LOG,
                                      logfile: LOGFILE)
    summary.display_error_summary()
    summary.display_flaky_summary()
  end
end
