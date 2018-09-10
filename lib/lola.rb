require 'lola/version'
require 'docile'

module Lola
  require 'lola/errors/evaluation_error'
  require 'lola/errors/mapping_error'
  require 'lola/errors/trigger_error'
  require 'lola/errors/type_error'
  require 'lola/types/type'
  require 'lola/query/data'
  require 'lola/query/joinable'
  require 'lola/query/query'
  require 'lola/query/not'
  require 'lola/query/look_back'
  require 'lola/query/source'
  require 'lola/store/stream'
  require 'lola/store/data_store'
  require 'lola/store/class_callback'
  require 'lola/dsl/spec'
  require 'lola/dsl/model'

  class Data
    prepend Lola::Joinable
  end

  def self.spec(sources = {}, &block)
    spec = Lola::Spec.new
    sources.each do |name, type|
      spec.define(name, type) do
        Lola::Source.new(name, type)
      end
    end
    thing = Docile.dsl_eval(spec, &block)
    # puts thing.inspect
    thing
  end
end

class Symbol
  prepend Lola::Joinable

  def query_inspect
    to_s
  end
end

class Integer
  prepend Lola::Joinable

  def query_inspect
    to_s
  end
end

class TrueClass
  def and(other)
    other
  end

  def or(other)
    true
  end
end

class FalseClass
  def and(other)
    false
  end

  def or(other)
    other
  end
end

Lola::Joinable.override_class_comparisons(Symbol)
