require 'google_drive'
require 'curl'

class Client
  BASE_URL = 'https://www.fundamentus.com.br'
  SEGMENT_URL = "#{BASE_URL}/resultado.php?segmento="
  STOCK_URL = "#{BASE_URL}/detalhes.php?papel="
  USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0) Gecko/20100101 Firefox/78.0"

  def segment_page(segment_page)
    url = "#{SEGMENT_URL}#{segment_page}"
    get(url, { "User-Agent" => USER_AGENT })
  end

  def stock_page(ticker)
    url = "#{STOCK_URL}#{ticker}"
    get(url, headers = { "User-Agent" => USER_AGENT })
  end

  def get(url, headers)
    Curl::Easy.perform(url) do |curl|
      curl.headers = { "User-Agent" => USER_AGENT }
    end
  end
end

module Fundamenthus
  module Source
    class Fundamentus
      attr_accessor :ws, :client

      SEGMENT_LIMIT = 100

      def initialize(ws, client = Client.new)
        @ws = ws
        @client = client
      end

      def fetch_stocks
        results = []
        segment_page = 0
        SEGMENT_LIMIT.times do
          begin
            segment_page += 1
            print "\r#{segment_page*100/SEGMENT_LIMIT}% complete - #{results.count} items fetched"
            sleep(2)

            response = @client.segment_page(segment_page)

            tickers = parser_stocks_name(response)

            next if tickers.empty?

            results.push(
              stock_details(tickers)
            )
          rescue => e
            puts e.message
            next
          end
        end

        save_to_ws(results)
      end

      private

      def save_to_ws(results)
        results = results.flatten

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
