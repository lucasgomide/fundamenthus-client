module Fundamenthus
  module Source
    module B3
      class Crawler
        attr_accessor :client

        HEADS = {
          'Tipo de Ativo' => :tipo_ativo,
          'Data da Aprovação (I)' => :data_aprovacao,
          'Valor do Provento (R$)' => :valor_provento,
          'Proventos por unidade ou mil' => :provento_unidade,
          'Tipo do Provento (II)' => :tipo_provento,
          'Últ. Dia \'Com\'' => :ult_dia_com,
          'Data do Últ. Preço \'Com\' (III)' => :data_ult_preco_com,
          'Últ. Preço \'Com\'' => :ult_preco_com,
          'Preço por unidade ou mil' => :preco_unidade,
          'Provento/Preço(%)' => :porcentage_provento_preco
        }

        APPLY = {
          data_aprovacao: :date_parser,
          data_ult_preco_com: :date_parser,
          ult_dia_com: :date_parser,
          porcentage_provento_preco: :float_parser,
          ult_preco_com: :float_parser,
          valor_provento: :float_parser,
          provento_unidade: :interger_parser,
          preco_unidade: :interger_parser
        }

        def initialize(client = Client.new)
          @client = client
        end

        def fetch_stocks
          file = File.read(File.join(File.dirname(__FILE__), './cvm_codes.json'))
          companies = JSON.parse(file).select { |c| c['SITUAÇÃO REGISTRO'] =~ /Concedido/ }
          results = []
          companies.each do |company|
            print "\r#{results.count} earnings fetched"
            begin
              response = @client.company_page(company['CÓDIGO CVM'])

              if response.status.to_i != 200
                puts 'status code not 200'
                next
              end


              document = Nokogiri::HTML(response.body)
              company = codigo_parser(document, company)

              response = @client.earnings_page(company['CÓDIGO CVM'])

              next if response.status.to_i != 200

              document = Nokogiri::HTML(response.body)
            rescue => e
              puts e.message
              next
            end

            results = dividendos_parser(document.css('.MasterTable_SiteBmfBovespa'), company, results)
          end
        end

        def codigo_parser(document, company)
          company.tap do |c|
            c['codigos'] = document.css('.LinkCodNeg').map(&:content).uniq.join(', ')
          end
        end

        def dividendos_parser(document, company, results = [])
          results.tap do |r|
            head_titles = HEADS.keys

            document.css('.MasterTable_SiteBmfBovespa thead th').each_with_index do |th, index|
              raise "Head '#{head_titles[index]}' não mapeado" unless head_titles[index] == th.content
            end

            document.css('.MasterTable_SiteBmfBovespa tbody tr').each do |tr|
              result = {'Nome' => company['NOME'], 'codigos' => company['codigos']}
              tr.css('td').each_with_index do |td, index|
                result[HEADS[head_titles[index]]] = send(APPLY[HEADS[head_titles[index]]] || :default_parser, td.content)
              end
              r << result
            end
          end
        end

        def date_parser(value)
          date_group = value.match(/(\d{0,2})\/(\d{0,2})\/(\d{0,4})/)
          return value if date_group.nil?
          date = date_group.to_a[1, 3].map(&:to_i)
          Date.new(date[2], date[1], date[0])
        end

        def float_parser(value)
          value.tr('.', '').tr(',', '.').to_f
        end

        def interger_parser(value)
          value.to_i
        end

        def default_parser(value)
          value
        end
      end
    end
  end
end
