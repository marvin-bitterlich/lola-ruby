module Lola
  class Spec
    def initialize
      @store = DataStore.new
    end

    def define(symbol, type, &block)
      @store.reserve symbol, type do
        thing = Lola::Data.new(yield block)
        @store.define symbol, thing
      end
    end

    def trigger(symbol, reason = '')
      @store.trigger symbol, reason
    end

    def look_back(symbol, steps, default)
      @store.look_back symbol, steps, default
    end

    def mapping(symbol)
      @store.retrieve symbol
    end

    def print(symbol)
      mapping(symbol).query
    end

    def trigger?(symbol)
      @store.trigger? symbol
    end

    def inspect
      "<Lola:Spec #{@store.inspect}>"
    end

    def evaluate(values = {})
      @store.evaluate(values)
    end

    def no(value)
      Lola::Not.new(Lola::Data.new value)
    end

    def l(value)
      Lola::Data.new(value)
    end
  end
end