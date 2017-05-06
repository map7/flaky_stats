# FlakyStats

Collects broken tests from a parallel failing test log, uses them to rerun the flaky tests and if they pass whilst running them on their own add them to the flaky_stats.log file.

At the end of the tests we can display a flaky stats summary which should display the top flaky tests in order of the most flakiest.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'flaky_stats'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install flaky_stats

## Usage

    $ rake parallel:rerun

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/map7/flaky_stats.

## Ref

http://andyatkinson.com/blog/2014/06/23/sharing-rake-tasks-in-gems

