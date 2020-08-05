require 'fundamenthus/source/b3/stocks'
require 'fundamenthus/source/b3/earnings'
require 'fundamenthus/source/b3/client'

module Fundamenthus
  module Source
    module B3
      def self.stocks
        Stocks.new.stocks
      end

      def self.earnings
        Earnings.new.earnings
      end
    end
  end
end
