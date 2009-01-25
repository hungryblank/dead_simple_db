module DeadSimpleDb

  class SdbNull

    NULL_VALUES = [nil, '', 'NULL']

    def initialize(value, opts={})
      raise "#{value} is not a null value" unless NULL_VALUES.member?(value)
    end

    def casted
      nil
    end

    def to_s
      'NULL'
    end

  end

end
