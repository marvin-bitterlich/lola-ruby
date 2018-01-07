module Lola
  class Data
    def initialize(value)
      @value = value
    end

    def evaluate(values)
      return @value if @value.kind_of? Numeric
      if @value.kind_of? Symbol
        if values.respond_to? @value
          return values.send @value
        end
        return values[@value]
      end
      if @value.respond_to? :evaluate
        return @value.evaluate(values)
      end
      raise "Not sure how to respond to #{values} with #{@value}"
    rescue => e
      raise Lola::EvaluationError, "#{e.message} in #{self.query_inspect}"
    end

    def inspect
      "<Δ↦#{@value.inspect}>"
    end

    def query_inspect
      @value.to_s
    end
  end
end