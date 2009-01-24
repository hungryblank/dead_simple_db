class Employee < DeadSimpleDb::Base

  domain 'test_domain'

  attr_sdb :name, 'String'
  attr_sdb :surname, 'String'
  attr_sdb :number, 'Integer', :digits => 10
  attr_sdb :rating, 'Float', :digits => 10, :decimals => 4
  attr_sdb :joined, 'Date'
  attr_sdb :last_login, 'Time'

end
