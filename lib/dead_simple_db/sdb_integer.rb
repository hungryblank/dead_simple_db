module DeadSimpleDb

  class SdbInteger

    DEFAULT_OPTS = {:digits => 6}

    def initialize(value, opts={})
      @opts = DEFAULT_OPTS.merge(opts)
      @value_before_cast = value
    end

    def casted
      @casted ||= @value_before_cast.to_i
    end

    def to_s
      @string ||= casted.to_s.rjust(@opts[:digits], '0')
    end

  end

end
