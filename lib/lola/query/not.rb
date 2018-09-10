module Lola
  class Not
    include Lola::Joinable

    def initialize(value)
      @value = value
    end

    def inspect
      "not(#{@value.inspect})"
    end

    def evaluate(values)
      result = check_evaluate(@value, values)
      return !result
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
      value_type = @value.compute_types(types)
      return :boolean if value_type == :boolean
      raise Lola::TypeError, "type mismatch on not(#{value_type.inspect}}) for #{self.inspect}"
    end

    private

    def check_evaluate(query, values)
      if query.respond_to? :evaluate
        return query.evaluate(values)
      end
      query
    end
  end
end