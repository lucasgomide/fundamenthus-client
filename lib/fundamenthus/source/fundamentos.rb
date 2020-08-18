require 'fundamenthus/source/fundamentos/stocks'
require 'fundamenthus/source/fundamentos/earnings'
require 'fundamenthus/source/fundamentos/client'

module Fundamenthus
  module Source
    module Fundamentos
      def self.stocks
        Fundamenthus::Source::Result.new(
          Stocks.new.collect
        )
      end

      def self.earnings
        Fundamenthus::Source::Result.new(
          Earnings.new.collect
        )
      end
    end
  end
end
