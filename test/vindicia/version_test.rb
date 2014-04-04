require 'helper'
require 'net/http'

class Vindicia::VersionTest < Test::Unit::TestCase
  def test_is_the_correct_version
    assert_equal Vindicia::VERSION, '0.1.0'
  end
end
