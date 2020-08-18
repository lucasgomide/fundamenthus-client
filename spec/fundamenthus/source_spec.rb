RSpec.describe Fundamenthus::Source do
  subject(:source) { described_class }

  context '.available' do
    subject(:available) { described_class.available }
    it { is_expected.to match_array(['b3', 'status_invest', 'fundamentos']) }
  end
end
