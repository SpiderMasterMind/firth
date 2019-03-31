require 'firth'
require 'json_parser'
require 'stream_data'
require 'ffmpeg_request'

RSpec.describe do
  describe Firth do
    subject { described_class.new(options) }
    let(:options) do
      { 
        # todo stream data 'request'? for ref.
        stream_data_class: stream_data_class,
        json_parser_class: json_parser_class,
        ffmpeg_request_class: ffmpeg_request_class
      }
    end

    let(:stream_data_class) do
      class_double(StreamData, new: stream_data)
    end

    # todo  instance_double
    let(:stream_data) { double('stream_data') }

    let(:json_parser_class) do
      class_double(JsonParser, new: double)
    end

    let(:ffmpeg_request_class) do
      class_double(FfmpegRequest, new: double)
    end

    it { is_expected.to be_a(described_class) }

    describe '#run' do
      subject(:run) { described_class.new(options).run }

      it 'instantiates the stream data object' do
        expect(stream_data_class).to receive(:new)
        run
      end

      it 'instantiates the json parser object' do
        expect(json_parser_class).to receive(:new)
        run
      end

      it 'instantiates the json parser object with stream data object' do
        expect(json_parser_class).to receive(:new).with(
          hash_including(stream_data: stream_data))
        run
      end

      xit 'instantiates the json parser object with fields to display' do
        expect(json_parser_class).to receive(:new).with(
          hash_including(fields: fields))
        run
      end

      it 'instantiates the ffmpeg service with a url' do
        expect(ffmpeg_request_class).to receive(:new)
        run
      end
    end
  end
end
