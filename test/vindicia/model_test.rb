require 'helper'
require 'vindicia/util'

class Vindicia::ModelTest < Test::Unit::TestCase
  
  def setup
    Vindicia::Configuration.class_eval do
      def self.reset_configured!
        @@configured = false
      end
    end
    Vindicia.class_eval do
      def self.clear_config
        if Vindicia.config.is_configured?
          API_CLASSES[Vindicia.config.api_version].each_key do |vindicia_klass|
            Vindicia.send(:remove_const, Vindicia::Util.camelize(vindicia_klass.to_s).to_sym) 
          end
          Vindicia::Configuration.reset_configured!
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
      end
    end
    assert Vindicia.config.is_configured?
  end

  def teardown
    Vindicia.clear_config
  end

  def test_should_define_api_methods_of_respective_vindicia_class_for_respective_api_version
    Vindicia::API_CLASSES[@good_api_version].each_key do |vindicia_klass_name|

      vindicia_klass = Vindicia.const_get(Vindicia::Util.camelize(vindicia_klass_name.to_s))

      Vindicia::API_CLASSES[@good_api_version][vindicia_klass_name].each do |api_method|
        assert vindicia_klass.respond_to?(api_method)
      end
    end
  end

  def test_should_catch_exceptions_thrown_underneath_savon
    Vindicia::AutoBill.client.expects(:request).once.raises(TimeoutError)

    resp = Vindicia::AutoBill.update({})

    assert_not_nil resp
    assert resp.to_hash
    assert_equal '500', resp[:update_response][:return][:return_code]
  end
end
