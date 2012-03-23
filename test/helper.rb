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

require 'minitest/autorun'
require 'minitest/unit'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'vindicia-api'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'test/fixtures/vcr_cassettes'
  c.hook_into :fakeweb
end

class MiniTest::Unit::TestCase
  private

  def configure_with(version = '3.6', login = 'YOUR LOGIN', password = 'YOUR PASSWORD')
    Vindicia.configure do |config|
      config.api_version = version 
      config.login = login
      config.password = password 
      config.endpoint = 'https://soap.prodtest.sj.vindicia.com/soap.pl'
      config.namespace = 'http://soap.vindicia.com'
    end
  end
end

Vindicia.class_eval do
  def self.clear_config
    if Vindicia.config.is_configured?
      Vindicia.reset_cache
    end
  end
end

require 'mocha'
