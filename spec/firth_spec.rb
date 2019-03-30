require 'firth'

RSpec.describe do
  describe Firth do
    subject { described_class.new(options) }
    let(:options) { '' }

    it { is_expected.to be_a(described_class) }

    describe '#run' do
      subject { described_class.new(options).run }

      it { is_expected.to be_nil }
    end
  end
end
