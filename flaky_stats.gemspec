# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'flaky_stats/version'

Gem::Specification.new do |spec|
  spec.name          = "flaky_stats"
  spec.version       = FlakyStats::VERSION
  spec.authors       = ["Michael Pope"]
  spec.email         = ["michael@dtcorp.com.au"]

  spec.summary       = %q{Records flaky tests}
  spec.description   = %q{Flaky stats will rerun broken tests from your parallel tests and if they pass then they must be flaky so it records them.}
  spec.homepage      = "http://github.com/map7/flaky_stats"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "timecop", "= 0.8.1"
  spec.add_development_dependency "byebug"
end
