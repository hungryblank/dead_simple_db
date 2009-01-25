require File.dirname(__FILE__) + '/test_helper'

class SdbNullTest < Test::Unit::TestCase

  include DeadSimpleDb

  should "cast a string to nil" do
    null = SdbNull.new('')
    assert_equal nil, null.casted
  end

  should "be identical if provided a nil" do
    null = SdbNull.new(nil)
    assert_equal nil, null.casted
  end

  should "be a NULL when converted to string" do
    null = SdbNull.new('')
    assert_equal 'NULL', null.to_s
  end

  should "raise an exception if provided a non null string" do
    assert_raise(RuntimeError) { SdbNull.new('4') }
  end

end
