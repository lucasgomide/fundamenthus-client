require 'curl'

module Fundamenthus
  module Source
    module B3
      class Client
        BASE_URL = 'http://bvmf.bmfbovespa.com.br'
        COMPANY_URL = "#{BASE_URL}/pt-br/mercados/acoes/empresas/ExecutaAcaoConsultaInfoEmp.asp?CodCVM="
        EARNINGS_URL = "#{BASE_URL}/cias-Listadas/Empresas-Listadas/ResumoProventosDinheiro.aspx?codigoCvm="

        USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0) Gecko/20100101 Firefox/78.0"

        def company_page(cvm_code)
          url = "#{COMPANY_URL}#{cvm_code}"
          get(url)
        end

        def earnings_page(cvm_code)
          url = "#{EARNINGS_URL}#{cvm_code}&idioma=pt-br"
          get(url)
        end

        def get(url)
          Curl::Easy.perform(url) do |curl|
            curl.timeout = 10
            curl.headers = {
              "User-Agent" => USER_AGENT,
              'host' => "bvmf.bmfbovespa.com.br",
              'Referer' => 'http://bvmf.bmfbovespa.com.br/',
              'Connection' => "keep-alive"
            }
          end
        end
      end
    end
  end
end
