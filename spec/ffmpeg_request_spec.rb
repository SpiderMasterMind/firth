# frozen_string_literal: true

require 'ffmpeg_request'
require 'exceptions/ffmpeg_service_error'

describe FfmpegRequest do
  subject(:ffmpeg_request) { described_class.new(options) }
  let(:options) do
    {
      cli_client: cli_client,
      response_parser_class: response_parser_class,
      stream_url: 'https://example.com'
    }
  end

  let(:cli_client) { double('cli_client', capture3: capture3_response) }

  let(:capture3_response) do
    [String, String, status_object]
  end

  let(:response_parser_class) do
    class_double(FfmpegResponseParser, new: response_parser)
  end

  let(:response_parser) { double('response_parser', process: nil) }

  let(:status_object) { double('status', success?: success) }
  let(:success) { true }

  it { is_expected.to be_a(described_class) }

  describe '#execute' do
    subject(:execute) { ffmpeg_request.execute }

    it 'calls the cli client' do
      expect(cli_client).to receive(:capture3).with(any_args)
      execute
    end

    context 'when ffmpeg request fails' do
      let(:success) { false }
      it 'throws an error if no success' do
        expect { execute }.to raise_error(FfmpegServiceError)
      end
    end
  end

  describe '#process_request' do
    subject(:process_request) do
      ffmpeg_request.execute.parsed_output
    end

    it 'calls the response parser' do
      expect(response_parser_class).to receive(:new)
      process_request
    end
  end
end
