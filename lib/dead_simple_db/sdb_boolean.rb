module DeadSimpleDb

  class SdbBoolean

    def initialize(value, opts={})
      @value_before_cast = value
    end

    def casted
      @casted = if @value_before_cast || false
        if @value_before_cast.respond_to?(:downcase)
          @value_before_cast.downcase == 'false' ? false : true
        else
          true
        end
      else
        false
      end
    end

    def to_s
      casted.to_s.upcase
    end

  end

end
