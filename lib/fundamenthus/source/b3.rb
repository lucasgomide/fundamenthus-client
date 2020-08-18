require 'fundamenthus/source/b3/stocks'
require 'fundamenthus/source/b3/earnings'
require 'fundamenthus/source/b3/client'

module Fundamenthus
  module Source
    module B3
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
