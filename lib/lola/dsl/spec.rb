module Lola
  class Spec
    def define(symbol, &block)
      thing = yield block
      puts thing, symbol
    end
  end
end