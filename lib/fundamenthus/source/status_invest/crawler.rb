require 'google_drive'
require 'pry'

module Fundamenthus
  module Source
    module StatusInvest
      class Crawler
        attr_accessor :ws, :client

        MAX_PAGE = 8

        def initialize(ws, client = Client.new)
          @ws = ws
          @client = client
        end

        def fetch_stocks
          results = []

          (1..MAX_PAGE).each do |page|
            begin
              response = @client.stock_links(page)

              break if response.status.to_i != 200

              JSON.parse(response.body_str).each do |company|
                print "\r#{page / MAX_PAGE.to_f * 100}% complete - #{results.count} items fetched"

                response = @client.stock_page(company['url'])
                result = parse_stock_page(response)
                result['Ação'] = company['url'].split('/').last.upcase
                result['Empresa'] = company['companyName']

                results << result
              end
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

        def parse_stock_page(response)
          doc = Nokogiri::HTML(response.body)
          {}.tap do |result|
            doc.css("i, .indicators[data-group] > strong, .card:contains('aluguel de ações')").remove
            doc.css(".top-info .info").map do |info|
              push(info, result)
            end
            doc.css('.indicators .item').map do |indicator|
              push(indicator, result)
            end
          end
        end

        def apply_normalizer(key, value, result)
          case key.downcase
            when 'dividend yield'
              result['Dividend Yield Ult 12 Meses (R$)'] = value[-1]
              result[key] = value[0..1].join(' ')
            when 'valorização (12m)'
              result[key] = value[0]
            when
              'min. 52 semanas',
              'máx. 52 semanas'
              result[key] = value[-1..].join(' ')
            when
              'liq. méd. diária',
              'part. ibov'
              result[key] = value[-2..].join(' ')
            when 'valor atual'
              result[key] = value[0..1].join(' ')
            else
              result[key] = value.is_a?(Array) ? value.join(' ') : value
          end
        end

        def push(value, result)
          content = value.text.strip.split("\n")
          return if reject_content(content[0])
          apply_normalizer(
            content[0],
            content[1..].reject(&method(:reject_content)),
            result
          )
        end

        def reject_content(field)
          field.gsub(/[[:space:]]/, '').empty? ||
            ['help_outline', 'arrow_upward', 'arrow_forward', 'arrow_downward'].include?(field.downcase)
        end
      end
    end
  end
end
