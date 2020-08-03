require 'curl'

module Fundamenthus
  module Source
    module StatusInvest
      class Client
        BASE_URL = 'https://statusinvest.com.br'.freeze
        STOCK_LINKS_URL = "#{BASE_URL}/acao/companiesnavigation".freeze
        USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0) Gecko/20100101 Firefox/78.0'.freeze

        def stock_links(page)
          url = "#{STOCK_LINKS_URL}?page=#{page}&size=50"
          get(url, { 'User-Agent' => USER_AGENT })
        end

        def stock_page(path)
          url = "#{BASE_URL}#{path}"
          get(url, { 'User-Agent' => USER_AGENT })
        end

        def get(url, _headers)
          Curl::Easy.perform(url) do |curl|
            curl.headers = { 'User-Agent' => USER_AGENT }
          end
        end
      end
    end
  end
end
