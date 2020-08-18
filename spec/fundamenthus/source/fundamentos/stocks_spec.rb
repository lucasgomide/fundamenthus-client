RSpec.describe Fundamenthus::Source::Fundamentos::Stocks, :vcr do
  subject(:stocks) { described_class.new }

  context '.collect' do
    let(:expected_result) { load_json_file('sources/fundamentos/stocks/data.json') }
    subject(:collect) { stocks.collect }

    it { is_expected.to eql(expected_result) }
  end
end
