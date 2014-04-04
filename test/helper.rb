require 'rubygems'
require 'bundler'
require 'singleton_reset'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'vindicia-api'

class Test::Unit::TestCase
end

require 'mocha/setup'
require 'webmock/test_unit'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'test/fixtures/vcr_cassettes'
  c.hook_into :webmock
end

Savon.configure do |config|
  config.log = false
end

HTTPI.log = false
