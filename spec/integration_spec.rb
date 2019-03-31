# frozen_string_literal: true

require 'firth'
require 'stream_data_request'
require 'ffmpeg_request'
require 'ffmpeg_response_parser'
require 'exceptions/ffmpeg_service_error'

describe 'integration test' do
  let(:url) { 'https://example.com' }
  let(:payload) do
    YAML.load_file('spec/fixtures/netil.yml')["standard"].to_json
  end

  before do
    stub_request(:get, url)
      .to_return(status: 200, body: payload)
  end

  xit 'The YAML load is making this test hang.' do
    firth = Firth.new(
      stream_data_request_class: StreamDataRequest,
      ffmpeg_request_class: FfmpegRequest,
      output: [],
      url: url
    )

    expect { firth.run }.to output.to_stdout
  end
end
