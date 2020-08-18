require 'csv'

module Fundamenthus
  module Source
    class Result < Array
      def to_csv(options = {})
        csv = [first.keys.to_csv(options)] + map(&:values).map { |v| v.to_csv(options) }
        csv.join
      end

      def to_html
        Fundamenthus.logger.info(__method__) { 'TODO: not implemented' }
        nil
      end
    end
  end
end
