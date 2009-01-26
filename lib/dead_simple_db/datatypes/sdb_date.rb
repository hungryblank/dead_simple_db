module DeadSimpleDb

  class SdbDate

    DEFAULT_OPTS = {:format => '%Y-%m-%d'}

    def initialize(value, opts={})
      @opts = DEFAULT_OPTS.merge(opts)
      @value_before_cast = value
    end

    def casted
      @casted = @value_before_cast if @value_before_cast.is_a?(Date)
      @casted ||= begin
        if @value_before_cast.respond_to?(:to_date)
          @value_before_cast.to_date
        elsif Date.respond_to?(:strptime)
          Date.strptime(@value_before_cast, @opts[:format])
        else
          Date.new(*(@value_before_cast.split('-').map { |n| n.to_i }))
        end
      end
    end

    def to_s
      @string ||= casted.strftime(@opts[:format])
    end

  end

end
