require File.dirname(__FILE__) + '/test_helper'
Dir.glob(File.dirname(__FILE__) + '/dummies/*.rb').each do |file|
  require file
end

class DeadSimpleDbTest < Test::Unit::TestCase

  def setup
    @service = Mocha::Mock.new
    @arturo = Employee.new(:name => 'Arturo', :surname => 'Bandini')
    AwsSdb::Service.stubs(:new).returns(@service)
    Employee.reconnect!
  end

  should "create the domain with setup" do
    @service.expects(:list_domains).returns([])
    @service.expects(:create_domain).with('test_domain')
    Employee.setup
  end

  should "put attributes on save" do
    @arturo.expects(:serial).returns('serial_1').times(2)
    put_hash = @arturo.attributes_hash_for_call
    @service.expects(:put_attributes).with('test_domain', 'serial_1', put_hash).returns(nil)
    @arturo.save
  end


  should "delete attributes on destroy" do
    @arturo.expects(:serial).returns('serial_1')
    @service.expects(:delete_attributes).with('test_domain', 'serial_1').returns(nil)
    @arturo.destroy
  end

  should "add class name to call hash" do
    assert_equal 'Employee', @arturo.attributes_hash_for_call[:class_name]
  end

  should "have a serial based on timestamp" do
    Time.stubs(:now).returns(Time.utc(2000,"jan",1,20,15,1))
    assert_equal Digest::MD5.hexdigest('nameArturosurnameBandini946757701.0'), @arturo.serial
  end

  should "have a serial not based on timestamp if uniq index is specified" do
    Employee.uniq(:name, :surname)
    Time.stubs(:now).returns(Time.utc(2000,"jan",1,20,15,1))
    assert_equal Digest::MD5.hexdigest('nameArturosurnameBandini'), @arturo.serial
  end

  should "get attributes when getting a specific record" do
    @service.expects(:get_attributes).with('test_domain', 'serial_1').returns({:name => 'Arturo', :surname => 'Bandini'})
    fetched_employee = Employee.get('serial_1')
    assert Employee = fetched_employee.class
    assert_equal 'serial_1', fetched_employee.serial
  end

  should "issue a query when finding ids" do
    @service.expects(:query).with('test_domain', "['name' = 'Arturo']", nil).returns(['e34979d4dc7b5b949fa67916acb63743'])
    Employee.find_ids(:all, "['name' = 'Arturo']")
  end

  should "fetch ids and after get attributes when finding" do
    Employee.expects(:find_ids).with(:all, "['name' = 'Arturo']", {}).returns(['e34979d4dc7b5b949fa67916acb63743'])
    Employee.expects(:get).with("e34979d4dc7b5b949fa67916acb63743")
    Employee.find(:all, "['name' = 'Arturo']")
  end

end
