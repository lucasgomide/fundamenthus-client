module Fundamenthus
  module Source
    module Fundamentos
      class Stocks
        include Fundamenthus::Source::Fields

        attr_accessor :client

        PAGE_LIMIT = 100

        def initialize(client = Client.new)
          @client = client
        end

        def stocks
          [].tap do |results|
            (1..PAGE_LIMIT).each do |page|
              print "\r#{page} pages parsed - #{results.count} items fetched"
              sleep(2)

              response = @client.segment_page(page)

              tickers = parser_stocks_name(response)

              next if tickers.empty?

              results.push(stock_details(tickers))
            rescue StandardError => e
              puts e.message
            end
          end.flatten
        end

        private

        def parser_stocks_name(response)
          doc = Nokogiri::HTML(response.body)
          doc.css("a[href*='detalhes.php?papel=']").map(&:content)
        end

        def stock_details(tickers)
          [].tap do |items|
            tickers.each do |ticker|
              response = @client.stock_page(ticker)
              doc = Nokogiri::HTML(response.body)
              item = {}
              labels = []
              data = []
              doc.css('.w728').each do |table|
                table.css('tr td').each do |td|
                  next if td.content.empty?

                  labels << td.content.strip.gsub(/\?/, '') if td.classes.include?('label')
                  data << td.content.strip if td.classes.include?('data')
                end
              end

              labels.each_with_index do |label, index|
                item[normalize_field(label)] = data[index]
              end
              items << item
            end
          end
        end
      end
    end
  end
end
