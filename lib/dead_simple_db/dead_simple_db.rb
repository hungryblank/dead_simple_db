require 'aws_sdb'
require 'digest/md5'

module DeadSimpleDb

  class Base

    attr_reader :attributes_hash

    class << self
      
      #Define the SimpleDb domain you want to use to store the current class
      #
      #  class Employee < DeadSimpleDb::Base
      #    
      #    domain 'hr_application'
      #
      #  end
      #
      #this will store all the instance of Employee class in the 'hr_application' domain
      def domain(domain = nil)
        return @domain unless domain
        @domain = domain
      end

      #Specify a set of attributes that should be unique across all the records
      def uniq(*args)
        return @uniq if args == []
        @uniq = args
      end

      #Refresh the current connection to SimpleDB
      def reconnect!
        @service = AwsSdb::Service.new
      end

      #The AwsSdb::Service currently used
      def service
        @service ||= AwsSdb::Service.new
      end

      #Create the SimpleDB domain used by the class
      def setup
        service.create_domain(@domain)
      end

      #Get a specific record identified by serial
      def get(serial)
        new(service.get_attributes(@domain, serial), :serial => serial)
      end


      def find(how_many, query, opts={})
        find_ids(how_many, query, opts).map { |o| get(o) }
      end

      def find_ids(how_many, query, opts={})
        limit = case how_many
          when :all : nil
          when :first : 1
        else
          how_many
        end
        service.query(@domain, query, limit).first
      end

      private

        def attr_sdb(name, klass, opts={})
          attributes << Attribute.new(name, klass, opts={})
        end

        def attributes
          @attributes ||= []
        end

    end

    #Create a new object passing an hash
    #
    #  new_employee = Emloyee.new(:name => 'Arturo', :surname => 'Bandini')
    #
    #please note that this does't stores the object on SimpleDB
    #it's the save method that performs the actual network operation of storing the data
    def initialize(attributes_hash, opts={})
      @attributes_hash = attributes_hash
      @serial = opts[:serial]
    end

    def attributes_hash_for_call
      attributes_hash.merge({:class_name => self.class.to_s})
    end

    #Save the current record on SimpleDB
    def save
      service.put_attributes(domain, serial, attributes_hash_for_call)
      serial
    end

    #Delete the current record from SimpleDB
    def destroy
      service.delete_attributes(domain, serial)
    end

    #The unique identifier fo the current record
    def serial
      @serial ||= begin
        serial = serial_string
        serial << Time.now.to_f.to_s unless uniq
        Digest::MD5.hexdigest(serial)
      end
    end

    private

      def service
        self.class.service
      end

      def domain
        self.class.domain
      end

      def uniq
        self.class.uniq
      end

      def serial_string
        labels = (@uniq || @attributes_hash.keys).map { |k| k.to_s }.sort
        labels.inject('') { |s, l| s << (l + @attributes_hash[l.to_sym].to_s) }
      end

  end

end
