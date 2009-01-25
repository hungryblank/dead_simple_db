module DeadSimpleDb

  class AttributeDefinition

    attr_reader :name

    def initialize(name, klass, opts={})
      @name, @klass, @opts = name, klass, opts 
    end

    def to_attr
      Attribute.new(@name, @klass, @opts)
    end

  end

end
