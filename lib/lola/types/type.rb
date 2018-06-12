module Lola
  class Type
    def self.compute_type_of(value, types)
      return :numeric if value.is_a? Numeric
      return :string if value.is_a? String
      return :boolean if value.is_a?(TrueClass) || value.is_a?(FalseClass)
      return value.compute_types(types) if value.respond_to? :compute_types
      return value.type if value.respond_to? :type
      if value.is_a? Symbol
        unless types.key? value
          raise Lola::TypeError, "Reference #{value.inspect} has no type in mapping #{types.inspect}"
        end
        return types[value]
      end
      raise Lola::TypeError, "Don't know what type a #{value.class} '#{value.inspect}' is…"
    end

    AR_MAPPING = {
      integer: :numeric,
      numeric: :numeric,
      string: :string,
      boolean: :boolean,
    }

    def self.convert_type_of(type)
      return AR_MAPPING[type] if AR_MAPPING.include? type
      raise Lola::TypeError, "AR type #{type} has no type in mapping #{AR_MAPPING}"
    end

    def self.convert_to_type(value, type)
      if type == :numeric
        return value.to_d if value.respond_to?(:to_d)
        return value.to_i if value.respond_to?(:to_i)
        return BigDecimal(value)
      end
      return value.to_s if type == :string
      return !!value if type == :boolean
      raise Lola::TypeError, "Cannot convert unknown type #{type} for value #{value.inspect}"
    end
  end
end