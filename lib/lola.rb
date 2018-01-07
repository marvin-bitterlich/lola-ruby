require 'lola/version'

module Lola
  require 'lola/errors/evaluation_error'
  require 'lola/query/joinable'
  require 'lola/query/query'
end

class Symbol
  include Lola::Joinable
end
