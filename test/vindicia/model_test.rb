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

  def test_should_catch_exceptions_thrown_underneath_savon
    Vindicia::AutoBill.client.expects(:request).once.raises(Timeout::Error)

    resp = Vindicia::AutoBill.update({})

    assert_not_nil resp
    assert resp.to_hash
    assert_equal '500', resp[:update_response][:return][:return_code]
  end

  def test_should_support_ruby_keyword_actions
    # this feature is used by WebSession, to support the initialize action, no huge rework, just escape codes
    assert Vindicia.config.is_configured?

    web_session = Vindicia::WebSession

    # method is available to be called
    web_session_methods = web_session.methods
    assert web_session_methods.include?(:_initialize)

    # method yields an action that is escaped
    resp = web_session._initialize(:ipAddress => '124.23.210.175',
                            :method => 'AutoBill_Update',
                            :returnUrl => 'https://merchant.com/subscribe/success.php',
                            :errorUrl => 'https://merchant.com/subscribe/failed.php',
                            :privatePormValues => [
                              { :name => 'Account_VID', :value => '36c8de2cb74b2c2b08b259cf231ac8d90d1bb3b8' },
                              { :name => 'Product_merchantProductId', :value => 'StartWars II' },
                              { :name => 'vin_BillingPlan_merchantBillingPlanId', :value => 'GoldAccess2010, PlatinumAccess2010' }
                            ],
                            :methodParamValues => [
                              { :name => 'AutoBill_Update_minChargebackProbability', :value => '80' }
                            ])
    assert_not_nil resp
    assert resp.to_hash
    # the fact that the response is enveloped in the escaped form of the action is evidence that the action was properly mapped
    assert_equal '403', resp[:initialize_response][:return][:return_code]
  end
end
