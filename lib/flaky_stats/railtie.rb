require 'flaky_stats'
require 'rails'
module FlakyStats
  class Railtie < Rails::Railtie
    railtie_name :flaky_stats

    rake_tasks do
      load "tasks/flaky_stats.rake"
    end
  end
end
