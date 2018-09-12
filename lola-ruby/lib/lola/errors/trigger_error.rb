module Lola
  class TriggerError < StandardError
    attr_reader :messages, :explanations
    def initialize(msg="No error supplied!", messages=[msg], explanations=[msg])
      @messages = messages
      @explanations = explanations
      super(msg)
    end
  end
end