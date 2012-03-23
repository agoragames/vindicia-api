# -*- encoding: utf-8 -*-
require File.expand_path('../lib/vindicia/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Tom Quackenbush", "Steven Davidovitz"]
  gem.email         = ["tquackenbush@agoragames.com"]
  gem.description   = %q{Builds an interface for creating queries to Vindicia CashBox API}
  gem.summary       = %q{Builds an interface for creating queries to Vindicia CashBox API}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "vindicia-api"
  gem.require_paths = ["lib"]
  gem.version       = Vindicia::VERSION

  gem.add_dependency('builder')

  gem.add_development_dependency('mocha')
  gem.add_development_dependency('fakeweb')
  gem.add_development_dependency('vcr')
end
