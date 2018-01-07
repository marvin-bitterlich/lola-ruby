module Lola
  module Joinable
    def +(other)
      Lola::Query.new(Lola::Data.new(self), Lola::Data.new(other), :+)
    end

    def -(other)
      Lola::Query.new(Lola::Data.new(self), Lola::Data.new(other), :-)
    end

    def ⇒(other)
      Lola::Query.new(Lola::Data.new(self), Lola::Data.new(other), :⇒)
    end

    def query_inspect
      to_s
    end
  end
end
