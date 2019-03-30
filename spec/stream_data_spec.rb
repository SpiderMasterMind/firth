require 'stream_data'

RSpec.describe do
  describe StreamData do
    subject { described_class.new(options) }
    let(:options) do 
      { url: url }
    end

    let(:url) { 'http://test.com' }
    let(:payload) do
      YAML.load_file("spec/fixtures/#{filename}").to_json
    end

    let(:filename) { 'netil.yml' }

    it { is_expected.to be_a(described_class) }

    describe '#fetch' do
      subject(:fetch) { described_class.new(options).fetch }
      before { stub_request(:get, options.fetch(:url)) }

      it 'makes a get request' do
        fetch
        expect(a_request(:get, options.fetch(:url))).to have_been_made
      end

      context 'with a working URL' do
        before do
          stub_request(:get, options.fetch(:url))
            .to_return(status: 200, body: payload)
        end

        it 'sets a status' do
          is_expected.to have_attributes(status: 200)
        end

        it 'sets a success flag' do
          is_expected.to have_attributes(success: true)
        end

        it 'sets the payload as the response body' do
          is_expected.to have_attributes(payload: payload)
        end
      end

      context 'with a non success URL' do
        context 'when the server is unresponsive' do
          before do
            stub_request(:get, options.fetch(:url))
              .to_return(status: 500)
          end

          it 'raises an error' do
            expect{ fetch }.to raise_error
          end
        end
      end

      context 'without a URL' do
        let(:url) { 'garbage' }
        it 'raises an error' do
          expect{ fetch }.to raise_error
        end
      end
    end
  end
end