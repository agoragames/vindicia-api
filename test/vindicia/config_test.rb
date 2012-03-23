require 'helper'
require 'vindicia/util'

class Vindicia::ConfigTest < MiniTest::Unit::TestCase

  def teardown
    Vindicia.clear_config
    Vindicia::Configuration.reset_instance
  end

  def test_should_configure_with_invalid_credentials
    assert !Vindicia.config.is_configured?

    VCR.use_cassette('should_configure_with_invalid_credentials') do
      configure_with('3.6', 'omg', 'wrong')
    end
    
    assert Vindicia.config.is_configured?
  end

  def test_should_not_configure_on_upsupported_api_version
    assert !Vindicia.config.is_configured?

    assert_raises RuntimeError do
      VCR.use_cassette('should_not_configure_on_upsupported_api_version') do
        configure_with('0.0')
      end
    end

    assert !Vindicia.config.is_configured?
  end

  def test_should_not_raise_exception_on_reconfigure
    assert !Vindicia.config.is_configured?

    VCR.use_cassette('should_not_raise_exception_on_reconfigure_1') do
      configure_with
    end
    assert Vindicia.config.is_configured?
    
    assert_raises RuntimeError do
      VCR.use_cassette('should_not_raise_exception_on_reconfigure_2') do
        configure_with('3.5')
      end

    end
  end

  def test_should_define_vindicia_classes_for_respective_api_version
    assert !Vindicia.config.is_configured?

    VCR.use_cassette('should_define_vindicia_classes_for_respective_api_version') do
      configure_with('3.6')
    end

    assert Vindicia.config.is_configured?

    # Some classes that are almost definitely not going away
    ['Account', 'Transaction', 'AutoBill'].each do |klass|
      assert Vindicia.const_defined?(klass)
    end
  end

  def test_classes_are_cached
    assert !Vindicia.config.is_configured?

    VCR.use_cassette('classes_are_cached_1') do
      configure_with
    end
    assert Vindicia.config.is_configured?
    assert File.exists?(Vindicia.instance_variable_get(:@api_yaml_file) % { :version => '3.6' })

    Vindicia::Configuration.reset_instance
    YAML.expects(:load_file)

    VCR.use_cassette('classes_are_cached_2') do
      configure_with
    end

  end
end
