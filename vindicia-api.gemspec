# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'vindicia/version'

Gem::Specification.new do |gem|
  gem.name          = 'vindicia-api'
  gem.version       = Vindicia::VERSION
  gem.authors       = ['Tom Quackenbush', 'Victor Garro']
  gem.email         = ['tquackenbush@agoragames.com', 'vgarro@verticalresponse.com']
  gem.homepage      = 'https://github.com/agoragames/vindicia-api'
  gem.summary       = %q{A wrapper for creating queries to the Vindicia CashBox API}
  gem.description   = %q{Provides a Singleton series of classes to communicate with Vindicia's Cashbox API}
  gem.license       = 'Copyright (c) 2011-2013 Agora Games'

  gem.rubyforge_project = 'vindicia-api'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency('savon', '= 1.3.0')
  gem.add_dependency('activesupport')
  gem.add_dependency('retriable')

  gem.add_development_dependency('rake')
  gem.add_development_dependency('minitest', '~> 4.7')
  gem.add_development_dependency('mocha', '~> 0.14.0')
end
