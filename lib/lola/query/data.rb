module Lola
  class Data
    def initialize(value)
      @value = value
      @type = nil
    end

    def evaluate(values)
      return @value if @value.kind_of? Numeric
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
      @type = compute_type_of @value, types
    end

    private
    def compute_type_of(value, types)
      return :numeric if value.is_a? Numeric
      return :string if value.is_a? String
      return :boolean if value.is_a?(TrueClass) || value.is_a?(FalseClass)
      return value.compute_types(types) if value.respond_to? :compute_types
      return value.type if value.respond_to? :type
      if value.is_a? Symbol
        unless types.key? value
          raise Lola::TypeError, "Reference #{value.inspect} has no type in mapping #{types.inspect}"
        end
        return types[value]
      end
      raise Lola::TypeError, "Don't know what type a #{value.class} '#{value.inspect}' is…"
    end
  end
end