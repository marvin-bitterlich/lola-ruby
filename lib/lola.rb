require 'lola/version'

module Lola
  require 'lola/errors/evaluation_error'
  require 'lola/query/data'
  require 'lola/query/joinable'
  require 'lola/query/query'

  class Data
    include Lola::Joinable
  end
end

class Symbol
  include Lola::Joinable
end
