module Lola
  module Joinable
    def +(other)
      Lola::Query.new(self, other.to_sym, :+)
    end

    def -(other)
      Lola::Query.new(self, other.to_sym, :-)
    end

    def ⇒(other)
      Lola::Query.new(self, other.to_sym, :⇒)
    end

    def query_inspect
      to_s
    end
  end
end
