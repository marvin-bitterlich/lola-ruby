module Lola
  class ClassCallback

    $mappings = {}

    def self.around_create(instance, &block)
      class_key = instance.class.to_s.to_sym
      instance_id = instance.respond_to?(:id) ? instance.id : instance.__id__
      unless $mappings.include? class_key
        $mappings[class_key] = {
          streams: {          }
        }
        $mappings[class_key][:streams][instance_id] = {
          instance: instance,
          id: instance_id
        }
      end
      puts $mappings
    end
  end
end