RSpec.describe Fundamenthus::Source::Result do
  subject(:source_result) { described_class.new(result) }
  let(:result) { [{ any_key: 'value 2' }, { any_key: 'value 10' }] }

  context '.to_html' do
    subject(:to_csv) { source_result.to_html }
    it { is_expected.to be_nil }
  end

  context '.to_csv' do
    subject(:to_csv) { source_result.to_csv }

    it { is_expected.to eql("any_key\nvalue 2\nvalue 10\n") }
  end
end
