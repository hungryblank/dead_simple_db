module DeadSimpleDb

  class SdbFloat

    include NegativeNumber

    DEFAULT_OPTS = {:digits => 8, :decimals => 2}

    def initialize(value, opts={})
      @opts = DEFAULT_OPTS.merge(opts)
      @value_before_cast = value
    end

    def casted
      @casted ||= @value_before_cast.to_f
    end

    def to_s
      @string ||= prepending_minus(casted.to_s) do |string|
          integer, decimal = *string.split('.')
          integer.rjust(@opts[:digits] - @opts[:decimals], '0') + '.' +
          decimal[0..@opts[:decimals] - 1].ljust(@opts[:decimals], '0')
      end
    end

  end

end
