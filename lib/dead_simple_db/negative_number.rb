module DeadSimpleDb 

  module NegativeNumber

    def negative?
      casted < 0
    end

    def prepending_minus(string)
      raise "needs a block" unless block_given?
      string.sub!('-', '') if negative?
      string = yield(string)
      negative? ? '-' + string : string
    end
  end

end
