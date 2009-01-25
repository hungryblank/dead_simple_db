module DeadSimpleDb

  class Attribute

    attr_reader :name
    attr_reader :value

    def initialize(name, klass, opts={})
      @name, @opts = name, klass
      self.klass = klass
    end

    def set=(value)
      @value = @klass.new(value)
    end

    private

      def klass=(klass)
        @klass = instance_eval('Sdb' + klass.to_s)
      end


  end

end
