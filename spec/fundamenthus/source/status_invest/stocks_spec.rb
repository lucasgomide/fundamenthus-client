RSpec.describe Fundamenthus::Source::StatusInvest::Stocks, :vcr do
  subject(:stocks) { described_class.new }

  context '.collect' do
    let(:expected_result) { load_json_file('sources/status_invest/stocks/data.json') }
    subject(:collect) { stocks.collect }

    it { is_expected.to match_array(expected_result) }
  end
end
