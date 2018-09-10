module Lola
  class ClassCallback

    $mappings = {}

    def self.retrieve_types(model)
      class_key = model.to_s.to_sym
      # compute types of that model
      # puts class_key.inspect

      types = model.respond_to?(:columns_hash) ? model.columns_hash : {}
      types = Hash[types.map do |name, type|
        new_type = Lola::Type.convert_type_of(type.sql_type_metadata.type.to_sym)
        # puts name, new_type
        [name.to_sym, new_type]
      end]
      unless $mappings.include? class_key
        $mappings[class_key] = {
            streams: {},
            types: types,
        }
      end

      types
    end

    def self.around_create(instance, &block)
      class_key = instance.class.to_s.to_sym
      instance_id = instance.respond_to?(:id) ? instance.id : instance.__id__
      spec = instance.class.__spec__

      types = $mappings[class_key][:types]
      # get values corresponding to the types
      values = Hash[types.map {|name, type| [name, Lola::Type.convert_to_type(instance.send(name), type)]}]

      # puts values.to_json

      unless $mappings[class_key][:streams].include? instance_id
        $mappings[class_key][:streams][instance_id] = {
            instance: instance,
            id: instance_id
        }
      end

      # puts $mappings.inspect

      # puts spec.inspect

      result = spec.evaluate values

      # puts result.inspect

      # puts spec.inspect

      db_result = yield block

        # puts db_result

        # puts "done"
    rescue Lola::TriggerError => e
      begin
        # When using Rails ensure that errors are reported better :tm:
        errors = Rails.env.development? ? e.messages : e.explanations
        errors.each do |error|
          instance.errors.add(:base, error)
        end
        raise ActiveRecord::RecordInvalid, instance
      rescue NameError
        raise e
      end
    end

    def self.around_update(instance, &block)
      self.around_create(instance, &block)
    end
  end
end