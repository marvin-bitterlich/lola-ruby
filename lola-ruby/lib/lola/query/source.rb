module Lola
  class Source
    def initialize(symbol, type)
      @symbol = symbol
      @type = type
    end

    def inspect
      "source(#{@symbol})"
    end

    def evaluate(values)
      values[@symbol]
    rescue => e
      raise Lola::EvaluationError, "#{e.message} in #{self.query_inspect}"
    end

    def to_sym
      @symbol
    end

    def to_s
      inspect
    end

    def query_inspect
      to_s
    end

    def compute_types(types)
      @type
    end
  end
end