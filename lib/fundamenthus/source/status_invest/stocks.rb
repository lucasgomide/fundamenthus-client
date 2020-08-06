module Fundamenthus
  module Source
    module StatusInvest
      class Stocks
        include Fundamenthus::Source::Fields

        attr_accessor :client

        MAX_PAGE = 8

        def initialize(client = Client.new)
          @client = client
        end

        def stocks
          [].tap do |results|
            (1..MAX_PAGE).each do |page|
              response = @client.stock_links(page)

              break if response.status.to_i != 200

              JSON.parse(response.body_str).each do |company|
                print "\r#{page} pages parsed - #{results.count} items fetched"

                response = @client.stock_page(company['url'])
                result = parse_stock_page(response)
                result['codigo'] = company['url'].split('/').last.upcase
                result['empresa'] = company['companyName']

                results << result
              end
            rescue StandardError => e
              puts e.message
              next
            end
          end.flatten
        end

        private

        def parse_stock_page(response)
          doc = Nokogiri::HTML(response.body)
          {}.tap do |result|
            doc.css("i, .indicators[data-group] > strong, .card:contains('aluguel de ações')").remove
            doc.css('.top-info .info').map do |info|
              push(info, result)
            end
            doc.css('.indicators .item').map do |indicator|
              push(indicator, result)
            end
          end
        end

        def apply_normalizer(key, value, result)
          case key
          when 'dividend_yield'
            result['dividend_yield_12_meses'] = value[-1]
            result[key] = value[0..1].join(' ')
          when 'valorização_12m'
            result[key] = value[0]
          when
              'min_52_semanas',
              'máx_52_semanas'
            result[key] = value[-1..].join(' ')
          when
              'liq_med_diaria',
              'part_ibov'
            result[key] = value[-2..].join(' ')
          when 'valor_atual'
            result[key] = value[0..1].join(' ')
          when 'ano_passado',
            'ano_atual',
            'comparação',
            'provisionado',
            'comparação_provisionado'
            result["dividendos_#{key}"] = value.join(' ')
          else
            result[key] = value.is_a?(Array) ? value.join(' ') : value
          end
        end

        def push(value, result)
          content = value.text.strip.split("\n")
          return if reject_content(content[0])

          apply_normalizer(
            normalize_field(content[0]),
            content[1..].reject(&method(:reject_content)),
            result
          )
        end

        def reject_content(field)
          field.gsub(/[[:space:]]/, '').empty? ||
            %w[help_outline arrow_upward arrow_forward arrow_downward].include?(field.downcase)
        end
      end
    end
  end
end
