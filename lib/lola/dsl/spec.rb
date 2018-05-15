module Lola
  class Spec
    def initialize
      @store = DataStore.new
    end

    def define(symbol, &block)
      thing = yield block
      puts thing, symbol
      @store.define symbol, thing
    end

    def trigger(symbol)
      @store.trigger symbol
    end

    def look_back(symbol, steps, default)
      @store.look_back symbol, steps, default
    end
  end
end