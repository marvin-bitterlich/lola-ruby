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
  end
end