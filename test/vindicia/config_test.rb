require 'helper'
require 'vindicia/util'

class Vindicia::ConfigTest < Test::Unit::TestCase

  def setup
    Vindicia.class_eval do
      def self.clear_config
        if Vindicia.config.is_configured?
          Vindicia::API_CLASSES[Vindicia.config.api_version].each_key do |vindicia_klass|
            Vindicia.send(:remove_const, Vindicia::Util.camelize(vindicia_klass.to_s).to_sym)
          end
        end
      end
    end
  end

  def teardown
    Vindicia.clear_config
    Vindicia::Configuration.reset_instance
  end

  def test_should_not_configure_on_upsupported_api_version
    assert !Vindicia.config.is_configured?

    bad_api_version = '0.0'
    assert !Vindicia::API_CLASSES.has_key?(bad_api_version)
    
    assert_nothing_raised do
      Vindicia.configure do |config|
        config.api_version = bad_api_version
        config.login = 'your_login'
        config.password = 'your_password' 
        config.endpoint = 'https://soap.prodtest.sj.vindicia.com/soap.pl'
        config.namespace = 'http://soap.vindicia.com'
      end
    end

    assert !Vindicia.config.is_configured?
  end

  def test_should_raise_exception_on_reconfigure
    good_api_version = '3.6'
    assert Vindicia::API_CLASSES.has_key?(good_api_version)
    assert !Vindicia.config.is_configured?

    assert_nothing_raised do
      Vindicia.configure do |config|
        config.api_version = good_api_version
        config.login = 'your_login'
        config.password = 'your_password' 
        config.endpoint = 'https://soap.prodtest.sj.vindicia.com/soap.pl'
        config.namespace = 'http://soap.vindicia.com'
      end
    end

    assert Vindicia.config.is_configured?
    
    some_other_api_version = '3.5'
    assert Vindicia::API_CLASSES.has_key?(some_other_api_version)

    assert_raise RuntimeError do
      Vindicia.configure do |config|
        config.api_version = good_api_version
        config.login = 'your_login'
        config.password = 'your_password'
        config.endpoint = 'https://soap.prodtest.sj.vindicia.com/soap.pl'
        config.namespace = 'http://soap.vindicia.com'
      end
    end
  end

  def test_should_define_vindicia_classes_for_respective_api_version
    good_api_version = '3.6'
    assert Vindicia::API_CLASSES.has_key?(good_api_version)
    assert !Vindicia.config.is_configured?

    assert_nothing_raised do
      Vindicia.configure do |config|
        config.api_version = good_api_version
        config.login = 'your_login'
        config.password = 'your_password' 
        config.endpoint = 'https://soap.prodtest.sj.vindicia.com/soap.pl'
        config.namespace = 'http://soap.vindicia.com'
      end
    end

    assert Vindicia.config.is_configured?

    Vindicia::API_CLASSES[good_api_version].each_key do |vindicia_klass|
      assert Vindicia.const_get(Vindicia::Util.camelize(vindicia_klass.to_s))
    end
  end
  
end
