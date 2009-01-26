module DeadSimpleDb

  class SdbTime

    DEFAULT_OPTS = {:format => '%Y-%m-%d %H:%M:%S'}

    def initialize(value, opts={})
      @opts = DEFAULT_OPTS.merge(opts)
      @value_before_cast = value
    end

    def casted
      @casted = @value_before_cast if @value_before_cast.is_a?(Time)
      @casted ||= begin
        if @value_before_cast.respond_to?(:to_time)
          @value_before_cast.to_time
        else
          Time.local(*(@value_before_cast.split(/-|\s|:/).map { |n| n.to_i }))
        end
      end
    end

    def to_s
      @string ||= casted.strftime(@opts[:format])
    end

  end

end
