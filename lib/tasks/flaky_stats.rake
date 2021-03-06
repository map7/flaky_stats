require 'csv'

ENV["RAILS_ENV"]="test"         # Force test environment
LOGFILE=Rails.root + "log/flaky_tests.log"
FAILING_LOG=Rails.root + "tmp/failing_specs.log"

desc "Rerun failing parallel tests in a single thread"
task :flaky_stats => :environment do  |t|
  if File.exist?(FAILING_LOG)

    # Read failing log
    logfile = FlakyStats::LogFile.new(failing_log: FAILING_LOG, logfile: LOGFILE)
    failed_files = logfile.read_failing_log()

    # Run tests singularly.
    flaky_tests = FlakyStats::FlakyTests.new(logfile: LOGFILE)
    real_flaky_tests = flaky_tests.run(failed_files)

    # Write out the log file of real flaky tests
    logfile.write_flaky_stats(real_flaky_tests)

    # Display summaries
    summary = FlakyStats::Summary.new(failing_log: FAILING_LOG,
                                      flaky_tests_log: LOGFILE,
                                      failed_files: failed_files,
                                      real_flaky_tests: real_flaky_tests)
    summary.display_error_summary()
    summary.display_flaky_summary()
    summary.display_current_flakies()
    summary.display_failed_tests()

    # Rollover logfile
    summary.rollover_and_write()
  end
end
