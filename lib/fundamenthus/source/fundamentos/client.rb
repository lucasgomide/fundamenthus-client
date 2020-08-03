require 'curl'

module Fundamenthus
  module Source
    module Fundamentos
      class Client
        BASE_URL = 'https://www.fundamentus.com.br'.freeze
        SEGMENT_URL = "#{BASE_URL}/resultado.php?segmento=".freeze
        STOCK_URL = "#{BASE_URL}/detalhes.php?papel=".freeze
        USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0) Gecko/20100101 Firefox/78.0'.freeze

        def segment_page(page)
          url = "#{SEGMENT_URL}#{page}"
          get(url)
        end

        def stock_page(ticker)
          url = "#{STOCK_URL}#{ticker}"
          get(url)
        end

        def get(url)
          Curl::Easy.perform(url) do |curl|
            curl.headers = { 'User-Agent' => USER_AGENT }
          end
        end
      end
    end
  end
end
