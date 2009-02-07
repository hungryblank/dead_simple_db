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

      #Gets a specific record identified by serial
      #
      # Employee.get("78af7ab2ebb10e71e7a936564621bbf3")
      #
      def get(serial)
        new(service.get_attributes(@domain, serial), :serial => serial)
      end

      #Lets you query the stored data
      #
      #to find the first employee who's name is Chuck
      #
      # Employee.find(:first, "['name' = 'Chuck']")
      #
      #to find all the employees who are designers
      #
      # Employee.find(:all, "['role' = 'designer']")
      #
      #please note the query syntax is SimpleDB custom syntax, refer to SimpleDB docs for details
      #
      def find(how_many, query, opts={})
        results, token = service.query_with_attributes(@domain, query, parse_limit(how_many))
        results.map! { |hash| new(hash) }
        return results.first if how_many == :first
        results
      end

      #The same as find but instead of returning the full object just returns
      #the object ids satisfyng the query
      #
      def find_ids(how_many, query, opts={})
        ids, token = service.query(@domain, query, parse_limit(how_many))
        ids
      end

      def attr_definitions
        @attr_definitions ||= []
      end

      private

        def attr_sdb(name, klass, opts={})
          define_method(name) do
            attributes_hash[name.to_sym].value
          end
          define_method("#{name}=") do |value|
            attributes_hash[name.to_sym].set(value)
          end
          attr_definitions << AttributeDefinition.new(name, klass, opts)
        end

        def parse_limit(how_many)
          limit = case how_many
            when :all : nil
            when :first : 1
          else
            how_many
          end
        end

    end

    #Instantiates a new object passing an hash
    #
    #  new_employee = Emloyee.new(:name => 'Arturo', :surname => 'Bandini')
    #
    #please note that this does't stores the object on SimpleDB
    #it's the save method that performs the actual network operation of storing the data
    def initialize(attributes_hash={}, opts={})
      read_attributes(attributes_hash)
      @serial = opts[:serial]
    end

    #Updates the attribute of the object using the hash passed as parameter
    def update_attributes(attributes_hash, opts={})
      read_attributes(attributes_hash)
    end

    def attributes_hash
      @attributes_hash ||= attributes.inject({}) do |hash, attribute|
        hash[attribute.name] = attribute
        hash
      end
    end

    def attributes_hash_for_call
      attributes_hash.merge({:class_name => self.class.to_s})
    end

    #Saves the current record on SimpleDB
    def save
      service.put_attributes(domain, serial, attributes_hash_for_call)
      serial
    end

    #Deletes the current record from SimpleDB
    def destroy
      service.delete_attributes(domain, serial)
    end

    #The unique identifier for the current record
    def serial
      @serial ||= begin
        serial = serial_string
        serial << Time.now.to_f.to_s
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

      def serial_string
        labels = attributes_hash.map { |k, v| k.to_s + v.to_s }.join('')
      end

      def read_attributes(hash)
        attribute_names = attributes.map { |a| a.name }
        attribute_names.map! { |an| an.to_s } if hash.keys.first.is_a?(String)
        attributes.each_with_index do |attribute, index|
          attribute.set(hash[attribute_names[index]])
        end
      end

      def attributes
        @attributes ||= self.class.attr_definitions.map { |d| d.to_attr }
      end

  end

end
