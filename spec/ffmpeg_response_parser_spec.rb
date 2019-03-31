require 'ffmpeg_response_parser'

describe FfmpegResponseParser do
  subject(:parser) { described_class.new(options) }
  let(:options) do
    {
      io: response
    }
  end

  let(:response) do
    YAML.load_file('spec/fixtures/ffmpeg_response.yml').fetch('volumedetect')
  end

  it { is_expected.to be_a(described_class) }

  describe '#process' do
    subject(:process) { parser.process }
    it 'prints fixture text to stdout' do
      expect { process }.to output(/ffmpeg version 4\.1\.2/).to_stdout
    end
  end
end
