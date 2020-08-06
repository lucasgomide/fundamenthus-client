module Fundamenthus
  module Source
    module Fields
      ACCENTED_LETTERS_MAP = {
        %w[á à â ä ã] => 'a',
        %w[Ã Ä Â À] => 'A',
        %w[é è ê ë] => 'e',
        %w[Ë É È Ê] => 'E',
        %w[í ì î ï] => 'i',
        %w[Î Ì] => 'I',
        %w[ó ò ô ö õ] => 'o',
        %w[Õ Ö Ô Ò Ó] => 'O',
        %w[ú ù û ü] => 'u',
        %w[Ú Û Ù Ü] => 'U',
        ['ç'] => 'c', ['Ç'] => 'C',
        ['ñ'] => 'n', ['Ñ'] => 'N'
      }.freeze

      def normalize_field(field)
        ACCENTED_LETTERS_MAP.each do |ac, rep|
          ac.each do |s|
            field = field.gsub(s, rep)
          end
        end
        field
          .gsub(%r{[^a-zA-Z0-9/ ]}, '')
          .gsub(/[ ]+/, ' ')
          .gsub(%r{\s+|/}, '_')
          .downcase
      end
    end
  end
end
