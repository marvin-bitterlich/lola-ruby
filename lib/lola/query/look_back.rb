module Lola
  class LookBack
    include Lola::Joinable

    def initialize(symbol, steps, default)
      @symbol = symbol
      @steps = steps
      @default = default
    end

    def inspect
      "<#{@symbol.inspect}Θ#{@steps.inspect}↦#{@default.query_inspect}>"
    end

    def evaluate(values)
      raise 'not yet implemented'
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
  end
end