require 'helper'

class Vindicia::ConfigTest < Test::Unit::TestCase

  def setup
    Vindicia.class_eval do
      def self.clear_config
        if Vindicia.config.is_configured?
          Vindicia::API_CLASSES[Vindicia.config.api_version].each_key do |vindicia_klass|
            Vindicia.send(:remove_const, vindicia_klass.to_s.camelize.to_sym)
          end
        end
      end
    end
  end

  def teardown
    Vindicia.clear_config
    Vindicia::Configuration.reset_instance
  end

  def set_config_values(config, api_version)
    config.api_version = api_version
    config.login = 'your_login'
    config.password = 'your_password'
    config.endpoint = 'https://soap.prodtest.sj.vindicia.com/soap.pl'
    config.namespace = 'http://soap.vindicia.com'
  end

  def test_should_not_configure_on_upsupported_api_version
    assert !Vindicia.config.is_configured?

    bad_api_version = '0.0'
    assert !Vindicia::API_CLASSES.has_key?(bad_api_version)

    assert_nothing_raised do
      Vindicia.configure do |config|
        set_config_values(config, bad_api_version)
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
        set_config_values(config, good_api_version)

        config.ssl_verify_mode = :none
        config.pretty_print_xml = true
      end
    end

    assert Vindicia.config.is_configured?

    some_other_api_version = '3.5'
    assert Vindicia::API_CLASSES.has_key?(some_other_api_version)

    assert_raise RuntimeError do
      Vindicia.configure do |config|
        set_config_values(config, some_other_api_version)
      end
    end
  end

  def test_should_define_vindicia_classes_for_respective_api_version
    good_api_version = '3.6'
    assert Vindicia::API_CLASSES.has_key?(good_api_version)
    assert !Vindicia.config.is_configured?
    logger = Logger.new(STDOUT)
    logger.level = Logger::WARN

    assert_nothing_raised do
      Vindicia.configure do |config|
        set_config_values(config, good_api_version)

        config.ssl_verify_mode = :none
        config.pretty_print_xml = true
        config.logger = logger
        config.log_filter = [:password]
        config.log_level = logger.level
        config.general_log = true
      end
    end

    assert Vindicia.config.is_configured?

    Vindicia::API_CLASSES[good_api_version].each_key do |vindicia_klass|
      assert Vindicia.const_get(vindicia_klass.to_s.camelize)
    end
  end

  def test_vindicia_websession_responds_to_init_call
    good_api_version = '3.6'
    assert Vindicia::API_CLASSES.has_key?(good_api_version)
    assert !Vindicia.config.is_configured?
    logger = Logger.new(STDOUT)
    logger.level = Logger::WARN

    assert_nothing_raised do
      Vindicia.configure do |config|
        set_config_values(config, good_api_version)

        config.ssl_verify_mode = :none
        config.pretty_print_xml = true
        config.logger = logger
        config.log_filter = [:password]
        config.log_level = logger.level
        config.general_log = true
      end
    end

    assert_respond_to(Vindicia::WebSession, :init)
    assert_not_respond_to(Vindicia::WebSession, :initialize)

  end

end
