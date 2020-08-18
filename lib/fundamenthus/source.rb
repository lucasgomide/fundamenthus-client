require 'fundamenthus/source/fields'
require 'fundamenthus/source/result'

require 'fundamenthus/source/fundamentos'
require 'fundamenthus/source/status_invest'
require 'fundamenthus/source/b3'

module Fundamenthus
  module Source
    def self.available
      ['b3', 'status_invest', 'fundamentos']
    end
  end
end
