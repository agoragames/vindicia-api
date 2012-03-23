require 'helper'
require 'vindicia/util'
require 'net/http'

require 'rexml/document'

class Vindicia::ModelTest < MiniTest::Unit::TestCase
  def setup
    assert !Vindicia.config.is_configured?

    VCR.use_cassette('model_test_setup') do
      configure_with
    end

    assert Vindicia.config.is_configured?

    Vindicia.send(:create_class, 'Testing')
    assert Vindicia.const_defined?('Testing')
  end

  def teardown
    Vindicia.clear_config
    Vindicia::Configuration.reset_instance
  end

  def test_actions_should_define_api_action
    Vindicia::Testing.actions(:auth)
    assert Vindicia::Testing.methods.include?(:auth)
  end

  def test_action_should_create_envelope
    Vindicia::Testing.actions(:auth)

    envelope = Vindicia::Testing.auth
    assert envelope.is_a?(String)

    document = REXML::Document.new(envelope)
    refute_empty document.elements.to_a('//env:Body') # envelope Body
    refute_empty document.elements.to_a('//tns:auth') # envelope action
    refute_empty document.elements.to_a('//auth') # required Vindicia auth
  end

  def test_action_should_create_envelope_with_complicated_params
    Vindicia::Testing.actions(:auth)

    envelope = Vindicia::Testing.auth(:this => { :is => [:really, { :sort => :of }], :complicated => 1 })
    document = REXML::Document.new(envelope)

    assert_equal 2, document.elements.to_a('//this/is').length

    assert_equal 1, document.elements.to_a('//this/is/sort').length
    assert_equal "of", document.elements.to_a('//this/is/sort').first.text

    assert_equal "1", document.elements.to_a('//this/complicated').first.text
  end
end
