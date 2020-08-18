module Fundamenthus
  module Source
    module StatusInvest
      class Earnings
        attr_accessor :client

        MAX_PAGE = 8

        def initialize(client = Client.new)
          @client = client
        end

        def collect
          results = []
          (1..MAX_PAGE).each do |page|
            response = @client.stock_links(page)

            break if response.status.to_i != 200

            JSON.parse(response.body_str).each do |company|
              print "\r#{page} pages parsed - #{results.count} earnings fetched"
              response = @client.stock_page(company['url'])
              results += parse_earnings(response, company)
            end
          rescue StandardError => e
            puts e.message
            next
          end
          results
        end

        private

        def parse_earnings(response, company)
          doc = Nokogiri::HTML(response.body)
          input = doc.css("#earning-section > input#results").first
          earnings = JSON.parse(input.attr(:value))
          stick = company['url'].split('/').last.upcase
          earnings.map do |r|
            {
              valor: r['v'],
              data_com: r['ed'],
              pagamento_data: r['pd'],
              tipo: r['et'],
              codigo: stick,
              empresa: company['companyName']
            }
          end
        end
      end
    end
  end
end
