RSpec.describe Fundamenthus::Source::Fundamentos::Earnings do
  subject(:earnings) { described_class.new }

  context '.collect' do
    subject(:collect) { earnings.collect }

    it { is_expected.to be_empty }
  end
end
