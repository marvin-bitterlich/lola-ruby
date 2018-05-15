module Lola
  class DataStore
    def initialize
      @mappings = {}
      @triggers = Set.new
    end

    def define(symbol, query)
      if @mappings.key? symbol
        raise MappingError, "In mapping #{@mappings.inspect} key #{symbol} was overridden from #{@mappings[symbol].inspect} to #{query.inspect}"
      end
      @mappings[symbol] = query
    end

    def trigger(symbol)
      @triggers.add symbol
    end

    def look_back(symbol, steps, default)

    end

    def retrieve(symbol)
      @mappings[symbol]
    end

    def trigger?(symbol)
      @triggers.include?(symbol)
    end
  end
end