module Lola
  class Spec
    def initialize
      @store = DataStore.new
    end

    def define(symbol, &block)
      thing = Lola::Data.new(yield block)
      # puts thing, symbol
      @store.define symbol, thing
    end

    def trigger(symbol)
      @store.trigger symbol
    end

    def look_back(symbol, steps, default)
      @store.look_back symbol, steps, default
    end

    def mapping(symbol)
      @store.retrieve symbol
    end

    def print(symbol)
      mapping(symbol)[:data].query_inspect
    end

    def trigger?(symbol)
      @store.trigger? symbol
    end
  end
end