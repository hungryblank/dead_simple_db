require File.dirname(__FILE__) + '/test_helper'

class SdbTimeTest < Test::Unit::TestCase

  include DeadSimpleDb

  should "cast a string to time" do
    time = SdbTime.new('2008-10-31 23:35:41')
    assert_equal Time.local(2008, 10, 31, 23, 35, 41), time.casted
  end

  should "be identical if provided a time" do
    time = SdbTime.new(Time.local(2008, 10, 31, 23, 35, 41))
    assert_equal Time.local(2008, 10, 31, 23, 35, 41), time.casted
  end

  should "be formatted if printed as string" do
    time = SdbTime.new(Time.local(2008, 10, 31, 23, 35, 41))
    assert_equal '2008-10-31 23:35:41', time.to_s
  end

end
