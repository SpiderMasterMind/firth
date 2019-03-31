# frozen_string_literal: true

require 'firth'
require 'stream_data_request'
require 'ffmpeg_request'

RSpec.describe do
  describe Firth do
    subject { described_class.new(options) }
    let(:options) do
      {
        stream_data_request_class: stream_data_request_class,
        ffmpeg_request_class: ffmpeg_request_class,
        stream_data_response: stream_data_response,
        output: firth_output,
        url: 'example.com'
      }
    end

    let(:firth_output) { [] }

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

    let(:stream_data) { double('stream_data') }
    let(:ffmpeg_request_class) do
      class_double(FfmpegRequest, new: ffmpeg_request)
    end

    let(:ffmpeg_request) do
      double('ffmpeg', execute: nil, parsed_output: ffmpeg_request_output)
    end

    let(:ffmpeg_request_output) { 'title' }

    it { is_expected.to be_a(described_class) }

    describe '#run' do
      subject(:run) { described_class.new(options).run }

      it 'calls the ffmpeg request service for each stream' do
        streams = stream_data_response.fetch('streams').length
        expect(ffmpeg_request_class).to receive(:new).exactly(streams).times
        run
      end

      it 'adds stream metadata to the output' do
        run
        expect(firth_output.join).to include('title')
      end

      it 'adds ffmpeg output properties data to the output' do
        run
        expect(firth_output.join).to include(ffmpeg_request_output)
      end
    end
  end
end
