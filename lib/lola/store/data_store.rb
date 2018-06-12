module Lola
  class DataStore
    def initialize
      @mappings = {}
      @types = {}
      @triggers = {}
      @reserved = nil
    end

    def reserve(symbol, type, &block)
      if @mappings.key? symbol
        raise MappingError, "In mapping #{@mappings.inspect} key #{symbol} was overridden from #{@mappings[symbol].inspect}"
      end
      @mappings[symbol] = Lola::Stream.new
      @types[symbol] = type
      yield block
    end

    # @param [Symbol] symbol
    def define(symbol, query)
      unless @mappings.key? symbol
        raise MappingError, "Cannot define #{query.inspect} on missing key #{symbol} in mapping #{@mappings.inspect}"
      end
      query.compute_types @types
      @mappings[symbol].attach_query query
    end

    # @param [Symbol] symbol
    def trigger(symbol, reason = '')
      unless @mappings.key? symbol
        raise MappingError, "Cannot add trigger on missing key #{symbol} in mapping #{@mappings.inspect}"
      end
      @triggers[symbol] = reason
    end

    # @param [Symbol] symbol
    def look_back(symbol, steps, default)
      unless @mappings.key?(symbol)
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
      mappings = @mappings.map { |k, m| "#{k}: #{m.query} :#{@types[k]}" }.join(",\n\t")
      streams = @mappings.map { |k, m| "#{k}: #{m.stream}" }.join(",\n\t")
      triggers = @triggers.map { |k, m| "#{k}: '#{m}'" }.join("\n\t")
      "mappings: {\n\t#{mappings}\n}, streams: {\n\t#{streams}\n}, triggers: {\n\t#{triggers}\n}"
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
      @triggers.each do |trigger, reason|
        trigger_value = values[trigger]
        if trigger_value
          values.delete(:__retrieve_look_back__)
          valuesoutput = values.map { |k, m| "#{k}: '#{m}'" }.join("\n\t")
          raise Lola::TriggerError.new(
            "Spec raised a violation with reason #{reason} in data state: \n#{self.inspect}, values: {\n\t#{valuesoutput}\n}"
          )
        end
      end
      @mappings.each do |key, mapping|
        mapping.push(values[key])
      end
      values
    end
  end
end