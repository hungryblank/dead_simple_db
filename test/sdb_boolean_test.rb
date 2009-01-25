require File.dirname(__FILE__) + '/test_helper'

class SdbBooleanTest < Test::Unit::TestCase

  include DeadSimpleDb

  should "cast correctly a true/false string" do
    boolean = SdbBoolean.new('true')
    assert_equal true, boolean.casted
    boolean = SdbBoolean.new('false')
    assert_equal false, boolean.casted
  end

  should "be identical if provided a boolean" do
    boolean = SdbBoolean.new(true)
    assert_equal true, boolean.casted
    boolean = SdbBoolean.new(false)
    assert_equal false, boolean.casted
  end

  should "be a string when converted to string" do
    boolean = SdbBoolean.new('yeah')
    assert_equal 'TRUE', boolean.to_s
    boolean = SdbBoolean.new('false')
    assert_equal 'FALSE', boolean.to_s
  end

end
