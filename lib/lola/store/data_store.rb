module Lola
  class DataStore
    def initialize
      @mappings = {}
      @triggers = Set.new
    end

    # @param [Symbol] symbol
    def define(symbol, query)
      if @mappings.key? symbol
        raise MappingError, "In mapping #{@mappings.inspect} key #{symbol} was overridden from #{@mappings[symbol].inspect} to #{query.inspect}"
      end
      @mappings[symbol] = Lola::Stream.new query
    end

    # @param [Symbol] symbol
    def trigger(symbol)
      unless @mappings.key? symbol
        raise MappingError, "Cannot add trigger on missing key #{symbol} in mapping #{@mappings.inspect}"
      end
      @triggers.add symbol
    end

    # @param [Symbol] symbol
    def look_back(symbol, steps, default)
      unless @mappings.key? symbol
        raise MappingError, "Cannot look back on missing key #{symbol} in mapping #{@mappings.inspect}"
      end
      retrieve(symbol).keep_at_least(steps)
      Lola::Data.new(Lola::LookBack.new(symbol, steps, default))
    end


    # @param [Symbol] symbol
    # @return [Lola::Stream]
    def retrieve(symbol)
      @mappings[symbol]
    end

    # @param [Symbol] symbol
    def trigger?(symbol)
      @triggers.include?(symbol)
    end

    def inspect
      mappings = @mappings.map {|k,m| "#{k}: #{m.query}"}.join(",\n\t")
      streams = @mappings.map {|k,m| "#{k}: #{m.stream}"}.join(",\n\t")
      triggers = @triggers.map {|m| m.to_s}.join(', ')
      "mappings: {\n\t#{mappings}\n}, streams: {\n\t#{streams}\n}, triggers: {#{triggers}}"
    end

    def retrieve_look_back(symbol, steps)
      @mappings[symbol].retrieve(steps)
    end

    def evaluate(values)
      values[:__retrieve_look_back__] = method(:retrieve_look_back)
      @mappings.each do |key, mapping|
        result = mapping.evaluate(values)
        values[key] = result
      end
      @mappings.each do |key, mapping|
        mapping.push(values[key])
      end
    end
  end
end