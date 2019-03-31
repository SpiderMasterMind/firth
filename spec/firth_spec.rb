require 'firth'
require 'stream_data_request'
require 'ffmpeg_request'

RSpec.describe do
  describe Firth do
    subject { described_class.new(options) }
    let(:options) do
      { 
        # todo stream data 'request'? for ref.
        stream_data_request_class: stream_data_request_class,
        ffmpeg_request_class: ffmpeg_request_class,
        stream_data_response: stream_data_response
      }
    end

    let(:stream_data_response) do
      JSON.parse(
        YAML.load_file(
          'spec/fixtures/stream_data_response.yml'
        ).fetch('netil')
      )
    end

    let(:stream_data_request_class) do
      class_double(StreamDataRequest, new: stream_data)
    end

    # todo  instance_double usage?
    let(:stream_data) { double('stream_data') }
    let(:ffmpeg_request_class) do
      class_double(FfmpegRequest, new: double)
    end

    it { is_expected.to be_a(described_class) }

    describe '#run' do
      subject(:run) { described_class.new(options).run }
      it 'instantiates the ffmpeg request object with a url' do
        expect(ffmpeg_request_class).to receive(:new)
        run
      end

      context 'with stream response json' do
        it 'calls the ffmpeg request service for each stream' do
          streams = stream_data_response.fetch("streams").length
          expect(ffmpeg_request_class).to receive(:new).exactly(streams).times
          run
        end
      end
    end
  end
end
