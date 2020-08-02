

module Fundamenthus
  module Source
    module Fundamentos
      class Crawler
        attr_accessor :storage, :client

        PAGE_LIMIT = 100

        def initialize(storage = nil, client = Client.new)
          @storage = storage
          @client = client
        end

        def fetch_stocks
          [].tap do |results|
            (1..PAGE_LIMIT).each do |page|
              begin
                print "\r#{page} pages parsed - #{results.count} items fetched"
                sleep(2)

                response = @client.segment_page(page)

                tickers = parser_stocks_name(response)

                next if tickers.empty?

                results.push(stock_details(tickers))
              rescue => e
                puts e.message
                next
              end
            end

            results = results.flatten

            if storage
              puts "\nSaving results to #{storage.class}.."
              storage.create(results)
            end
          end
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
              doc.css(".w728").each do |table|
                table.css('tr td').each do |td|
                  next if td.content.empty?
                  labels << td.content.strip.gsub(/\?/, '') if td.classes.include?('label')
                  data << td.content.strip if td.classes.include?('data')
                end
              end

              labels.each_with_index do |label, index|
                item[label] = data[index]
              end
              items << item
            end
          end
        end
      end
    end
  end
end
