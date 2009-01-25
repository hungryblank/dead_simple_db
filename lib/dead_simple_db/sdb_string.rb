module DeadSimpleDb

  class SdbString

    def initialize(value, opts={})
      @value_before_cast = value
    end

    def casted
      @casted = case @value_before_cast
        when String : @value_before_cast
        else
          @value_before_cast.to_s
      end
    end

    def to_s
      casted
    end

  end

end
