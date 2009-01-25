require File.dirname(__FILE__) + '/test_helper'

class SdbStringTest < Test::Unit::TestCase

  include DeadSimpleDb

  should "cast a integer to string" do
    string = SdbString.new(10)
    assert_equal '10', string.casted
  end

  should "be identical if provided a string" do
    string = SdbString.new('foo')
    assert_equal 'foo', string.casted
  end

  should "be a string when converted to string" do
    string = SdbString.new(1.1)
    assert_equal '1.1', string.to_s
  end

end
