require File.dirname(__FILE__) + '/test_helper'

class SdbDateTest < Test::Unit::TestCase

  include DeadSimpleDb

  should "cast a string to date" do
    date = SdbDate.new('2008-10-31')
    assert_equal Date.new(2008, 10, 31), date.casted
  end

  should "be identical if provided a date" do
    date = SdbDate.new(Date.new(2008, 10, 31))
    assert_equal Date.new(2008, 10, 31), date.casted
  end

  should "be formatted if printed as string" do
    date = SdbDate.new(Date.new(2008, 10, 31))
    assert_equal '2008-10-31', date.to_s
  end

end
