require File.dirname(__FILE__) + '/test_helper'

class AttributeTest < Test::Unit::TestCase

  include DeadSimpleDb

  should "set the name" do
    attribute = Attribute.new(:number, 'Integer')
    assert_equal :number, attribute.name
  end

  should "should instantiate the correct class" do
    SdbInteger.expects(:new).with('10', :decimals => 10)
    attribute = Attribute.new(:number, 'Integer', :decimals => 10)
    attribute.set('10')
  end

  should "should instantiate a null when a null value is passed" do
    null_value = SdbNull::NULL_VALUES.first
    SdbNull.expects(:new).with(null_value, :decimals => 10)
    attribute = Attribute.new(:number, 'Integer', :decimals => 10)
    attribute.set(null_value)
  end

  should "should call to_s on its value" do
    integer_mock = Mocha::Mock.new
    SdbInteger.expects(:new).with('10', :decimals => 10).returns(integer_mock)
    attribute = Attribute.new(:number, 'Integer', :decimals => 10)
    attribute.set('10')
    integer_mock.expects(:to_s)
    attribute.to_s
  end

  should "should cast to return value" do
    integer_mock = Mocha::Mock.new
    SdbInteger.expects(:new).with('10', :decimals => 10).returns(integer_mock)
    attribute = Attribute.new(:number, 'Integer', :decimals => 10)
    attribute.set('10')
    integer_mock.expects(:casted)
    attribute.value
  end

end
