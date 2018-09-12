module Lola
  class LookBack
    include Lola::Joinable

    def initialize(symbol, steps, default)
      @symbol = symbol
      @steps = steps
      @default = default
    end

    def inspect
      "look_back(#{@symbol}, #{@steps.inspect}, #{@default.query_inspect})"
    end

    def evaluate(values)
      values[:__retrieve_look_back__].call(@symbol, @steps) || @default
    rescue => e
      raise Lola::EvaluationError, "#{e.message} in #{self.query_inspect}"
    end

    def to_sym
      self
    end

    def to_s
      inspect
    end

    def query_inspect
      to_s
    end

    def compute_types(types)
      unless types.key? @symbol
        raise Lola::TypeError, "Look Back Reference #{@symbol.inspect} has no type in mapping #{types.inspect}"
      end
      types[@symbol]
    end
  end
end