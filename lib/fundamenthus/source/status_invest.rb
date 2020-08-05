require 'fundamenthus/source/status_invest/stocks'
require 'fundamenthus/source/status_invest/earnings'
require 'fundamenthus/source/status_invest/client'

module Fundamenthus
  module Source
    module StatusInvest
      def self.stocks
        Fundamenthus::Source::Result.new(
          Stocks.new.stocks
        )
      end

      def self.earnings
        Fundamenthus::Source::Result.new(
          Earnings.new.earnings
        )
      end
    end
  end
end
