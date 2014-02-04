# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'strategy_bag/version'

Gem::Specification.new do |spec|
  spec.name          = "strategy_bag"
  spec.version       = StrategyBag::VERSION
  spec.authors       = ["Levente Bagi"]
  spec.email         = ["bagilevi@gmail.com"]
  spec.summary       = %q{Ruby DSL for making conditionals more readable}
  spec.description   = %q{Ruby DSL for making conditionals more readable by defining a set of strategies. Each strategy has a set of conditions and an action. The runner will select a strategy that meets the conditions and executes it.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
