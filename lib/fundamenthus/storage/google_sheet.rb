require 'google_drive'

module Fundamenthus
  module Storage
    class GoogleSheet
      attr_writer :worksheet
      attr_accessor :ws, :session

      def initialize(spreadsheet_key)
        @session = GoogleDrive::Session
          .from_config("config.json")
          .spreadsheet_by_key(spreadsheet_key)
      end

      def worksheet=(worksheet)
        @ws = @session.worksheets[worksheet]
      end

      def create(results)
        results.first.keys.each_with_index do |key, index|
          ws[1, index + 1] = key
        end

        results.each_with_index do |item, head|
          item.values.each_with_index do |key, index|
            ws[head + 2, index + 1] = key
          end
        end

        ws.save
      end
    end
  end
end
