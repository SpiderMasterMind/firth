require 'firth'
require 'json_parser'
require 'stream_data'

RSpec.describe do
  describe Firth do
    subject { described_class.new(options) }
    let(:options) do
      { 
        stream_data_class: stream_data_class,
        json_parser_class: json_parser_class
      }
    end

    let(:stream_data_class) do
      class_double(StreamData, new: double)
    end

    let(:json_parser_class) do
      class_double(JsonParser, new: double)
    end

    it { is_expected.to be_a(described_class) }

    describe '#run' do
      subject(:run) { described_class.new(options).run }

      it 'instantiates the stream data object' do
        # todo next
        expect(stream_data_class).to receive(:new)
        run
      end
    end
  end
end
