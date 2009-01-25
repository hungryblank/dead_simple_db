module DeadSimpleDb

  class Attribute

    attr_reader :name

    def initialize(name, klass, opts={})
      @name, @opts = name, opts 
      self.klass = klass
    end

    def set(value)
      to_instantiate = @klass
      value = value.first if value.is_a?(Array) && !to_instantiate.respond_to?(:multiple)
      to_instantiate = SdbNull if SdbNull::NULL_VALUES.member?(value)
      @value = to_instantiate.new(value, @opts)
    end

    def to_s
      @value.to_s
    end

    def value
      @value.casted
    end

    private

      def klass=(klass)
        @klass = instance_eval('Sdb' + klass.to_s)
      end

  end

end
