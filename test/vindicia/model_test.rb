require 'helper'
require 'net/http'

class Vindicia::ModelTest < Test::Unit::TestCase

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

    @good_api_version = '3.6'
    assert Vindicia::API_CLASSES.has_key?(@good_api_version)
    assert !Vindicia.config.is_configured?

    assert_nothing_raised do
      Vindicia.configure do |config|
        config.api_version = @good_api_version
        config.login = 'your_login'
        config.password = 'your_password'
        config.endpoint = 'https://soap.prodtest.sj.vindicia.com/soap.pl'
        config.namespace = 'http://soap.vindicia.com'

        config.ssl_verify_mode = :none
        config.pretty_print_xml = true
      end
    end
    assert Vindicia.config.is_configured?
  end

  def teardown
    Vindicia.clear_config
    Vindicia::Configuration.reset_instance
  end

  def test_should_define_api_methods_of_respective_vindicia_class_for_respective_api_version
    Vindicia::API_CLASSES[@good_api_version].each_key do |vindicia_klass_name|

      vindicia_klass = Vindicia.const_get(vindicia_klass_name.to_s.camelize)

      Vindicia::API_CLASSES[@good_api_version][vindicia_klass_name].each do |api_method|
        assert vindicia_klass.respond_to?(api_method)
      end
    end
  end

  def test_should_catch_500_exceptions_thrown_underneath_savon
    Vindicia::AutoBill.client.expects(:request).once.raises(StandardError)

    resp = Vindicia::AutoBill.update({})

    assert_not_nil resp
    assert resp.to_hash
    assert_equal '500', resp[:update_response][:return][:return_code]
  end

  def test_should_catch_503_exceptions_thrown_underneath_savon
    Vindicia::AutoBill.client.expects(:request).once.raises(Timeout::Error)

    resp = Vindicia::AutoBill.update({})

    assert_not_nil resp
    assert resp.to_hash
    assert_equal '503', resp[:update_response][:return][:return_code]
  end
end
