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
      @mappings[symbol] = {
        data: query,
        look_back: 0,
      }
    end

    def trigger(symbol)
      unless @mappings.key? symbol
        raise MappingError, "Cannot add trigger on missing key #{symbol} in mapping #{@mappings.inspect}"
      end
      @triggers.add symbol
    end

    def look_back(symbol, steps, default)
      unless @mappings.key? symbol
        raise MappingError, "Cannot look back on missing key #{symbol} in mapping #{@mappings.inspect}"
      end
      mapping = retrieve symbol
      mapping[:look_back] = [mapping[:look_back], steps].max
      Lola::Data.new(Lola::LookBack.new(symbol, steps, default))
    end

    def retrieve(symbol)
      @mappings[symbol]
    end

    def trigger?(symbol)
      @triggers.include?(symbol)
    end

    def inspect
      mappings = @mappings.map {|k,m| "#{k}: #{m[:data].inspect}"}.join(",\n\t")
      triggers = @triggers.map {|m| m.to_s}.join(', ')
      "mappings: {\n\t#{mappings}\n}, triggers: {#{triggers}}"
    end
  end
end