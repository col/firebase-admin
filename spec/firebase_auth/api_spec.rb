require File.expand_path('../spec_helper', __dir__)

describe FirebaseAuth::API do
  before do
    @keys = FirebaseAuth::Configuration::VALID_OPTIONS_KEYS
  end

  context 'with module configuration' do
    before do
      FirebaseAuth.configure do |config|
        @keys.each do |key|
          config.send("#{key}=", key)
        end
      end
    end

    after do
      FirebaseAuth.reset
    end

    it 'should inherit module configuration' do
      api = FirebaseAuth::API.new
      @keys.each do |key|
        expect(api.send(key)).to eq(key)
      end
    end

    context 'with class configuration' do
      before do
        @configuration = {
          access_token: 'AT',
          adapter: :typhoeus,
          connection_options: { ssl: { verify: true } },
          endpoint: 'http://tumblr.com/',
          user_agent: 'Custom User Agent',
          project_id: 'test-project',
          loud_logger: true
        }
      end

      context 'during initialization' do
        it 'should override module configuration' do
          api = FirebaseAuth::API.new(@configuration)
          @keys.each do |key|
            expect(api.send(key)).to eq(@configuration[key])
          end
        end
      end

      context 'after initilization' do
        let(:api) { FirebaseAuth::API.new }

        before do
          @configuration.each do |key, value|
            api.send("#{key}=", value)
          end
        end

        it 'should override module configuration after initialization' do
          @keys.each do |key|
            expect(api.send(key)).to eq(@configuration[key])
          end
        end

        describe '#connection' do
          it 'should use the connection_options' do
            expect(Faraday::Connection).to receive(:new).with(include(ssl: { verify: true }))
            api.send(:connection)
          end
        end
      end
    end
  end

  describe '#config' do
    subject { FirebaseAuth::API.new }

    let(:config) do
      c = {}
      @keys.each { |key| c[key] = key }
      c
    end

    it 'returns a hash representing the configuration' do
      @keys.each do |key|
        subject.send("#{key}=", key)
      end
      expect(subject.config).to eq(config)
    end
  end

  describe 'loud_logger param' do
    before do
      @client = FirebaseAuth::Client.new(project_id: 'test-project', loud_logger: true)
    end

    context 'outputs to STDOUT with faraday logs when enabled' do
      before do
        stub_post('v1/projects/test-project/accounts')
          .to_return(body: fixture('create_account.json'), headers: { content_type: 'application/json; charset=utf-8' })
      end

      it 'should return the body error message' do
        output = capture_output do
          @client.create_account({})
        end

        expect(output).to include 'INFO -- : Started POST request to: '
        expect(output).to include 'DEBUG -- : Response Headers:'
        expect(output).to include "User-Agent    : Firebase Auth Ruby Gem #{FirebaseAuth::VERSION}"
      end
    end

    context 'shows STDOUT output when errors occur' do
      before do
        stub_post('v1/projects/test-project/accounts')
          .to_return(body: '{"error":{"message": "Bad words are bad."}}', status: 400)
      end

      it 'should return the body error message' do
        output = capture_output do
          @client.create_account({})
        rescue StandardError
          nil
        end

        expect(output).to include 'INFO -- : Started POST request to: '
        expect(output).to include 'DEBUG -- : Response Headers:'
        expect(output).to include "User-Agent    : Firebase Auth Ruby Gem #{FirebaseAuth::VERSION}"
        expect(output).to include '{"error":{"message": "Bad words are bad."}}'
      end
    end
  end
end
