module Lola
  class Stream
    def initialize
      @query = nil
      @look_back = 1
      @stream = []
    end

    def attach_query(query)
      @query = query
    end

    # @return [String]
    def query
      @query.inspect
    end

    # @param [Numeric] amount_of_steps
    # @return [Numeric]
    def keep_at_least(amount_of_steps)
      @look_back = [@look_back, amount_of_steps].max
    end

    def stream
      "#{@look_back}Φ#{@stream.inspect}"
    end

    def inspect
      "⟨#{query}, #{stream}⟩"
    end

    def push(value)
      @stream = @stream.prepend(value).slice(0, @look_back)
    end

    def retrieve(steps)
      @stream[steps-1]
    end

    def evaluate(values)
      @query.evaluate(values)
    end
  end
end