require "flaky_stats/version"
require "flaky_stats/summary"
require "flaky_stats/logfile"
require "flaky_stats/flaky_tests"

module FlakyStats
  require 'flaky_stats/railtie' if defined?(Rails)
end
