module Lola
  module Joinable
    def method_missing(method, *args)
      if BINARY_OPERATORS.include? method
        return binary_match(method, args.first)
      end
      return super
    end

    def self.override_class_comparisons(overridden_class)
      BINARY_OPERATORS.each do |operator|
        overridden_class.send(:define_method, operator) do |other|
          self.method_missing(operator, other)
        end
      end
    end

    private

    BINARY_OPERATORS = Set[:+, :-, :<, :>, :⇒]

    def binary_match(operator, other)
      return self.class.superclass.send(operator, other) unless matches_prepend other
      Lola::Query.new(Lola::Data.new(self), Lola::Data.new(other), operator)
    end

    def matches_prepend(other)
      [Symbol, Lola::Data, Lola::Query].find do |clazz|
        self.kind_of?(clazz) || other.kind_of?(clazz)
      end
    end
  end
end
