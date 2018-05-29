require 'lola/version'

module Lola
  require 'lola/errors/evaluation_error'
  require 'lola/errors/mapping_error'
  require 'lola/errors/trigger_error'
  require 'lola/query/data'
  require 'lola/query/joinable'
  require 'lola/query/query'
  require 'lola/query/look_back'
  require 'lola/store/stream'
  require 'lola/store/data_store'
  require 'lola/dsl/spec'

  class Data
    prepend Lola::Joinable
  end

  def self.spec(&block)
    thing = Docile.dsl_eval(Lola::Spec.new, &block)
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

Lola::Joinable.override_class_comparisons(Symbol)
