require File.dirname(__FILE__) + '/test_helper'
Dir.glob(File.dirname(__FILE__) + '/dummies/*.rb').each do |file|
  require file
end

class DeadSimpleDbTest < Test::Unit::TestCase

  include DeadSimpleDb

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
    @arturo.expects(:serial_string).returns('nameArturosurnameBandini')
    assert_equal Digest::MD5.hexdigest('nameArturosurnameBandini946757701.0'), @arturo.serial
  end

  should "get attributes when getting a specific record" do
    @service.expects(:get_attributes).with('test_domain', 'serial_1').returns({:name => 'Arturo', :surname => 'Bandini'})
    fetched_employee = Employee.get('serial_1')
    assert Employee = fetched_employee.class
    assert_equal 'serial_1', fetched_employee.serial
  end

  should "issue a query when finding ids" do
    @service.expects(:query).with('test_domain', "['name' = 'Arturo']", nil).returns([['e34979d4dc7b5b949fa67916acb63743'], ''])
    Employee.find_ids(:all, "['name' = 'Arturo']")
  end

  should "issue a query with attributes when finding" do
    @service.expects(:query_with_attributes).with('test_domain', "['name' = 'Arturo']", nil).returns([[{'name' => 'Arturo'}], ''])
    results = Employee.find(:all, "['name' = 'Arturo']")
    assert_equal 'Arturo', results.first.name
  end

  should "instantiate an attribute definition when sdb_attr is called" do
    AttributeDefinition.expects(:new).with(:number, 'Integer', :decimals => 10).returns('w')
    attr_def_ary = Mocha::Mock.new
    Employee.expects(:attr_definitions).returns(attr_def_ary)
    attr_def_ary.expects('<<').with('w')
    Employee.send(:attr_sdb, :number, 'Integer', :decimals => 10)
  end

  should "read attributes from hash with symbols or strings" do
    attribute = @arturo.send(:attributes).find { |a| a.name == :name }
    attribute.expects(:set).with('Arturo')
    @arturo.update_attributes(:name => 'Arturo')
    attribute.expects(:set).with('Arturo string')
    @arturo.update_attributes('name' => 'Arturo string')
  end

  should "build methods to access attributes" do
    assert_equal 'Arturo', @arturo.name
  end

end
