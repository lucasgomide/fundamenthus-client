require 'nokogiri'
require 'json'
require 'date'

module Fundamenthus
  module Source
    module B3
      class Earnings
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
        }.freeze

        APPLY = {
          data_aprovacao: :date_parser,
          data_ult_preco_com: :date_parser,
          ult_dia_com: :date_parser,
          porcentage_provento_preco: :float_parser,
          ult_preco_com: :float_parser,
          valor_provento: :float_parser,
          provento_unidade: :integer_parser,
          preco_unidade: :integer_parser
        }.freeze

        def initialize(client = Client.new)
          @client = client
        end

        def collect
          [].tap do |results|
            companies.each do |company|
              print "\r#{results.count} companies fetched"
              earnings = parse_company_earning(company)
              next if earnings.nil? || earnings.empty?

              results << earnings
            end
          end.flatten
        end

        def parse_company_earning(company)
          response = @client.company_page(company['CÓDIGO CVM'])
          return nil if response.status.to_i != 200

          company = add_sticker_to(company, response)
          response = @client.earnings_page(company['CÓDIGO CVM'])
          return nil if response.status.to_i != 200

          earning_parser(response, company)
        rescue StandardError => e
          puts e.message
          nil
        end

        def add_sticker_to(company, response)
          document = Nokogiri::HTML(response.body)
          sticker_parser(document, company)
        end

        private

        def companies
          file = File.read(File.join(File.dirname(__FILE__), './cvm_codes.json'))
          JSON.parse(file).select { |c| c['SITUAÇÃO REGISTRO'] =~ /Concedido/ }
        end

        def sticker_parser(document, company)
          company.tap do |c|
            c['stickers'] = document.css('.LinkCodNeg').map(&:content).uniq.join(', ')
          end
        end

        def earning_parser(response, company)
          document = Nokogiri::HTML(response.body).css('.MasterTable_SiteBmfBovespa')
          head_titles = HEADS.keys
          default_data = { 'empresa' => company['NOME'], 'papel' => company['stickers'] }
          [].tap do |result|
            data = {}
            document.css('.MasterTable_SiteBmfBovespa tbody tr').each do |tr|
              tr.css('td').each_with_index do |td, index|
                data[HEADS[head_titles[index]].to_s] = send(APPLY[HEADS[head_titles[index]]] || :default_parser, td.content)
              end
              result << data.merge(default_data)
            end
          end
        end

        def date_parser(value)
          date_group = value.match(%r{(\d{0,2})/(\d{0,2})/(\d{0,4})})
          return value if date_group.nil?

          date = date_group.to_a[1, 3].map(&:to_i)
          Date.new(date[2], date[1], date[0]).to_s
        end

        def float_parser(value)
          value.tr('.', '').tr(',', '.').to_f
        end

        def integer_parser(value)
          value.to_i
        end

        def default_parser(value)
          value
        end
      end
    end
  end
end
