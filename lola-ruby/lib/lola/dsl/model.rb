module Lola
  module Model
    def define_specification(*args, &block)
      types = Lola::ClassCallback.retrieve_types(self)
      around_create Lola::ClassCallback
      around_update Lola::ClassCallback
      @spec = Lola.spec(types, *args, &block)
    end

    def __spec__
      @spec
    end
  end
end