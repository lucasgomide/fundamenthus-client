RSpec.describe Fundamenthus::Source::B3 do
  subject(:source) { described_class }

  context '.stocks' do
    subject(:stocks) { described_class.stocks }
    let(:result) { [{ key: 'value' }, { key2: 'value2' }] }
    before do
      allow_any_instance_of(Fundamenthus::Source::B3::Stocks).to receive(:collect).and_return(result)
    end

    it { is_expected.to be_an_instance_of(Fundamenthus::Source::Result) }
    it { is_expected.to eql(result) }
  end

  context '.earnings' do
    subject(:earnings) { described_class.earnings }
    let(:result) { [{ key: 'value' }, { key2: 'value2' }] }
    before do
      allow_any_instance_of(Fundamenthus::Source::B3::Earnings).to receive(:collect).and_return(result)
    end

    it { is_expected.to be_an_instance_of(Fundamenthus::Source::Result) }
    it { is_expected.to eql(result) }
  end
end
