require 'aws_sdb'
require 'digest/md5'
Dir.glob(File.dirname(__FILE__) + '/dead_simple_db/**/*.rb').each do |lib|
  require lib
end

module DeadSimpleDb
end
