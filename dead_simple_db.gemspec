Gem::Specification.new do |s|
  s.name = %q{dead_simple_db}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Paolo Negri"]
  s.date = %q{2009-01-26}
  s.description = %q{TODO}
  s.email = %q{hungryblank@gmail.com}
  s.files = ["VERSION.yml", "lib/dead_simple_db.rb", "lib/dead_simple_db", "lib/dead_simple_db/negative_number.rb", "lib/dead_simple_db/dead_simple_db.rb", "lib/dead_simple_db/datatypes", "lib/dead_simple_db/datatypes/sdb_time.rb", "lib/dead_simple_db/datatypes/sdb_integer.rb", "lib/dead_simple_db/datatypes/sdb_float.rb", "lib/dead_simple_db/datatypes/sdb_null.rb", "lib/dead_simple_db/datatypes/sdb_string.rb", "lib/dead_simple_db/datatypes/sdb_date.rb", "lib/dead_simple_db/datatypes/sdb_boolean.rb", "lib/dead_simple_db/attribute.rb", "lib/dead_simple_db/attribute_definition.rb", "test/dead_simple_db_test.rb", "test/sdb_float_test.rb", "test/sdb_date_test.rb", "test/dummies", "test/dummies/employee.rb", "test/sdb_integer_test.rb", "test/sdb_string_test.rb", "test/attribute_test.rb", "test/sdb_time_test.rb", "test/sdb_boolean_test.rb", "test/test_helper.rb", "test/sdb_null_test.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/hungryblank/dead_simple_db}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Object oriented library to store data in Amazon SimpleDB AWS}
  s.add_dependency('aws-sdb', '>= 0.4.0')

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
    else
    end
  else
  end
end
