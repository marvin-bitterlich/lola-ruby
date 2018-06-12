module Lola
  module Model
    def define_specification(*args, &block)
      types = Lola::ClassCallback.retrieve_types(self)
      puts types.to_json
      around_create Lola::ClassCallback
      @@spec = Lola.spec(types, *args, &block)
    end

    def __spec__
      @@spec
    end
  end
end