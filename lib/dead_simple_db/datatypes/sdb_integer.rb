module DeadSimpleDb

  class SdbInteger

    include NegativeNumber

    DEFAULT_OPTS = {:digits => 6}

    def initialize(value, opts={})
      @opts = DEFAULT_OPTS.merge(opts)
      @value_before_cast = value
    end

    def casted
      @casted ||= @value_before_cast.to_i
    end

    def to_s
      @string ||= prepending_minus(casted.to_s) do |string|
        string.rjust(@opts[:digits], '0')
      end
    end

  end

end
