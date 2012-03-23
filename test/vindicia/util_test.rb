require 'helper'
require 'vindicia/util'

class Vindicia::UtilTest < MiniTest::Unit::TestCase
  def test_camelize_should_produce_camelCase_name_from_lowercase_underscore_name
    assert_equal 'fooBarBaz', Vindicia::Util.camelize('foo_bar_baz')
  end

  def test_demodulize_should_return_last_module
    assert_equal 'Transaction', 'Vindicia::Transaction'.demodulize
  end
end
