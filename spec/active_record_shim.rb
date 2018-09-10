# noinspection RubyClassVariableUsageInspection
module ActiveRecordShim
  def attributes(attributes)
    @attributes = {}
    @columns = {}
    attributes.each do |attribute, type|
      attr_accessor attribute
      @attributes[attribute] = type
      @columns[attribute] = {sql_type_metadata: {type: type}}
    end
  end

  def columns_hash
    Hashie::Mash.new(@columns)
  end

  def initialize(params)
    params.each do |attribute, value|
      self.send("#{attribute.to_s}=", value)
    end
  end

  def around_create(callback_class)
    @@callback_class = callback_class
  end

  def change_state()
    @@callback_class.around_create(self) do
      # puts :something
    end
  end
end