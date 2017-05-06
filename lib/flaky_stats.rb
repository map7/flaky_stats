require "flaky_stats/version"

module FlakyStats
  require 'flaky_stats/railtie' if defined?(Rails)
end
