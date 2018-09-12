module Lola
  class Data
    def initialize(value)
      @value = value
      @type = nil
    end

    def evaluate(values)
      return @value if @value.kind_of? Numeric
      return @value if @value.kind_of? TrueClass
      return @value if @value.kind_of? FalseClass
      if @value.kind_of? Symbol
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
      "#{@value.inspect}"
    end

    def to_s
      query_inspect
    end

    def query_inspect
      @value.to_s
    end

    def type
      @type
    end

    def compute_types(types)
      @type = Lola::Type.compute_type_of @value, types
    end
  end
end