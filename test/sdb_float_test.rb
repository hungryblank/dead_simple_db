require File.dirname(__FILE__) + '/test_helper'

class SdbFloatTest < Test::Unit::TestCase

  include DeadSimpleDb

  should "cast a string to float" do
    float = SdbFloat.new('10')
    assert_equal 10.0, float.casted
  end

  should "be identical if provided a float" do
    float = SdbFloat.new(10.0)
    assert_equal 10.0, float.casted
  end

  should "be casted if provided an integer" do
    float = SdbFloat.new(10)
    assert_equal 10.0, float.casted
  end

  should "be padded if printed as string" do
    float = SdbFloat.new(100.1, :digits => 6)
    assert_equal '0100.10', float.to_s
  end

  should "be trimmed if string is too long" do
    float = SdbFloat.new(100.11231312312, :digits => 6)
    assert_equal '0100.11', float.to_s
  end

end
