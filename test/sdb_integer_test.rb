require File.dirname(__FILE__) + '/test_helper'

class SdbIntegerTest < Test::Unit::TestCase

  include DeadSimpleDb

  should "cast a string to integer" do
    integer = SdbInteger.new('10')
    assert_equal 10, integer.casted
  end

  should "be identical if provided an integer" do
    integer = SdbInteger.new(10)
    assert_equal 10, integer.casted
  end

  should "be casted if provided a float" do
    integer = SdbInteger.new(10.99)
    assert_equal 10, integer.casted
  end

  should "be padded if printed as string" do
    integer = SdbInteger.new(10, :digits => 6)
    assert_equal '000010', integer.to_s
  end

  should "be padded and have minus if printed as string" do
    integer = SdbInteger.new(-10, :digits => 6)
    assert_equal '-000010', integer.to_s
  end

  should "handle minus if provided negative string" do
    integer = SdbInteger.new('-15', :digits => 6)
    assert_equal '-000015', integer.to_s
  end

end
