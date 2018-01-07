require 'lola/version'

module Lola
  require 'lola/errors/evaluation_error'
  require 'lola/query/data'
  require 'lola/query/joinable'
  require 'lola/query/query'

  class Data
    prepend Lola::Joinable
  end

  def self.spec(&block)

  end
end

class Symbol
  prepend Lola::Joinable
  def query_inspect
    to_s
  end
end
