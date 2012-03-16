require 'helper'
require 'vindicia/util'

class Vindicia::UtilTest < Test::Unit::TestCase
  def test_camelize_should_produce_camalcase_name_from_lowercase_underscore_name
    assert_equal 'FooBarBaz', Vindicia::Util.camelize('foo_bar_baz')
  end
end