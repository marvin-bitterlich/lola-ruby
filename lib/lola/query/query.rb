module Lola
  class Query
    include Lola::Joinable

    def initialize(left, right, operand)
      @left = left
      @right = right
      @operand = operand
    end

    def inspect
      "(#{@left.query_inspect} #{@operand.query_inspect} #{@right.query_inspect})"
    end

    def evaluate(values)
      left_value = check_evaluate(@left, values)
      right_value = check_evaluate(@right, values)
      raise "Operator mismatch in #{self.query_inspect}" unless left_value.respond_to? @operand
      left_value.send(@operand, right_value)
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
      left_type = @left.compute_types(types)
      right_type = @right.compute_types(types)
      if left_type == :numeric
        if [:+, :-, :*, :/].include? @operand
          return :numeric if right_type == :numeric
        end
        if [:>, :<, :>=, :<=, :==, :!=].include? @operand
          return :boolean if right_type == :numeric
        end
      end
      if left_type == :boolean
        if [:==, :!=].include? @operand
          return :boolean if right_type == :boolean
        end
      end
      raise Lola::TypeError, "type mismatch on (#{left_type.inspect} #{@operand.to_s} #{right_type.inspect}) for #{self.inspect}"
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