RSpec.describe Fundamenthus::Source::B3::Stocks do
  subject(:stocks) { described_class.new }

  context '.collect' do
    subject(:collect) { stocks.collect }
    it { is_expected.to be_empty }
  end
end
