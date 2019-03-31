# frozen_string_literal: true

require 'ffmpeg_response_parser'

describe FfmpegResponseParser do
  subject(:parser) { described_class.new(options) }
  let(:options) do
    {
      io: response,
      filter: filter
    }
  end

  let(:response) do
    YAML.load_file('spec/fixtures/ffmpeg_response.yml').fetch('volumedetect')
  end

  let(:filter) { nil }
  it { is_expected.to be_a(described_class) }

  describe '#process' do
    subject(:process) { parser.process }
    context 'with no filter' do
      it 'returns all the input' do
        expect(process).to eql(response)
      end
    end

    context 'with a filter' do
      let(:filter) { %w[mean_volume max_volume] }
      it 'returns the filtered line' do
        filtered = response.split("\n").select do |line|
          filter.any? { |_f| !filter.include?(line) }
        end
        expect(process).not_to eql(filtered)
      end
    end
  end
end
