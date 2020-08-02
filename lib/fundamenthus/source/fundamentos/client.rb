require 'curl'

module Fundamenthus
  module Source
    module Fundamentos
      class Client
        BASE_URL = 'https://www.fundamentus.com.br'
        SEGMENT_URL = "#{BASE_URL}/resultado.php?segmento="
        STOCK_URL = "#{BASE_URL}/detalhes.php?papel="
        USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0) Gecko/20100101 Firefox/78.0"

        def segment_page(page)
          url = "#{SEGMENT_URL}#{page}"
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
    end
  end
end
