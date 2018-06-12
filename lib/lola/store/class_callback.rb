module Lola
  class ClassCallback

    $mappings = {}

    def self.around_create(instance, &block)
      class_key = instance.class.to_s.to_sym
      instance_id = instance.respond_to?(:id) ? instance.id : instance.__id__

      unless $mappings.include? class_key
        # compute types of that model
        types = instance.respond_to?(:columns_hash) ? instance.columns_hash : {}
        types = Hash[types.map { |name, type| [name, Lola::Type.convert_type_of(type[:type])] }]

        $mappings[class_key] = {
          streams: {},
          types: types,
        }
      end

      types = $mappings[class_key][:types]
      # get values corresponding to the types
      values = Hash[types.map { |name, type| [name, Lola::Type.convert_to_type(instance.send(name), type)] }]

      puts values.inspect


      unless $mappings[class_key][:streams].include? instance_id
        $mappings[class_key][:streams][instance_id] = {
          instance: instance,
          id: instance_id
        }
      end
      puts $mappings
    end
  end
end