RSpec.describe Fundamenthus::Source::B3::Earnings, :vcr do
  subject(:earnings) { described_class.new }

  context '.collect' do
    let(:earning_data) { load_json_file('sources/b3/earnings/data.json') }
    let(:indexes) { (0..earning_data.count).to_a.sample(400) }
    let(:expected_result) { earning_data.values_at(*indexes) }

    subject(:collect) { earnings.collect.values_at(*indexes) }

    it { is_expected.to match_array(expected_result) }
  end
end

