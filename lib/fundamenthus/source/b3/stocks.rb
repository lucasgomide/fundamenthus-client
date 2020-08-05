require 'logger'

module Fundamenthus
  module Source
    module B3
      class Stocks
        def stocks
          logger = Logger.new(STDOUT)
          logger.info(__method__) { 'TODO: Crawler not implemented' }
          []
        end
      end
    end
  end
end
