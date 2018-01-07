module Lola
  module Joinable
    def +(other)
      return super(other) unless matches_prepend other
      Lola::Query.new(Lola::Data.new(self), Lola::Data.new(other), :+)
    end

    def -(other)
      return super(other) unless matches_prepend other
      Lola::Query.new(Lola::Data.new(self), Lola::Data.new(other), :-)
    end

    def ⇒(other)
      return super(other) unless matches_prepend other
      Lola::Query.new(Lola::Data.new(self), Lola::Data.new(other), :⇒)
    end

    private
    def matches_prepend(other)
      return true if self.kind_of? Lola::Query
      [Numeric, Symbol, Lola::Data, Lola::Query].find do |clazz|
        other.kind_of? clazz
      end
    end
  end
end
