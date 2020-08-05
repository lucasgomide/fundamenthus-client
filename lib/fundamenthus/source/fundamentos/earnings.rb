require 'logger'

module Fundamenthus
  module Source
    module Fundamentos
      class Earnings
        def earnings
          logger = Logger.new(STDOUT)
          logger.info(__method__) { 'TODO: Crawler not implemented' }
          []
        end
      end
    end
  end
end
