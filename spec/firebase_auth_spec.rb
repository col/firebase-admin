require File.expand_path('spec_helper', __dir__)

describe FirebaseAuth do
  after do
    FirebaseAuth.reset
  end

  context 'when delegating to a client' do
    before do
      FirebaseAuth.project_id = 'test-project'

      stub_post('v1/projects/test-project/accounts')
        .to_return(body: fixture('create_account.json'), headers: { content_type: 'application/json; charset=utf-8' })
    end

    it 'should get the correct resource' do
      FirebaseAuth.create_account({})
      expect(a_post('v1/projects/test-project/accounts')).to have_been_made
    end

    it 'should return the same results as a client' do
      expect(FirebaseAuth.create_account({})).to eq(FirebaseAuth::Client.new.create_account({}))
    end
  end

  describe '.client' do
    it 'should be a FirebaseAuth::Client' do
      expect(FirebaseAuth.client).to be_a FirebaseAuth::Client
    end
  end

  describe '.adapter' do
    it 'should return the default adapter' do
      expect(FirebaseAuth.adapter).to eq(FirebaseAuth::Configuration::DEFAULT_ADAPTER)
    end
  end

  describe '.adapter=' do
    it 'should set the adapter' do
      FirebaseAuth.adapter = :typhoeus
      expect(FirebaseAuth.adapter).to eq(:typhoeus)
    end
  end

  describe '.endpoint' do
    it 'should return the default endpoint' do
      expect(FirebaseAuth.endpoint).to eq(FirebaseAuth::Configuration::DEFAULT_ENDPOINT)
    end
  end

  describe '.endpoint=' do
    it 'should set the endpoint' do
      FirebaseAuth.endpoint = 'http://tumblr.com'
      expect(FirebaseAuth.endpoint).to eq('http://tumblr.com')
    end
  end

  describe '.user_agent' do
    it 'should return the default user agent' do
      expect(FirebaseAuth.user_agent).to eq(FirebaseAuth::Configuration::DEFAULT_USER_AGENT)
    end
  end

  describe '.user_agent=' do
    it 'should set the user_agent' do
      FirebaseAuth.user_agent = 'Custom User Agent'
      expect(FirebaseAuth.user_agent).to eq('Custom User Agent')
    end
  end

  describe '.loud_logger' do
    it 'should return the loud_logger status' do
      expect(FirebaseAuth.loud_logger).to be_nil
    end
  end

  describe '.loud_logger=' do
    it 'should set the loud_logger' do
      FirebaseAuth.loud_logger = true
      expect(FirebaseAuth.loud_logger).to be_truthy
    end
  end

  describe '.configure' do
    FirebaseAuth::Configuration::VALID_OPTIONS_KEYS.each do |key|
      it "should set the #{key}" do
        FirebaseAuth.configure do |config|
          config.send("#{key}=", key)
          expect(FirebaseAuth.send(key)).to eq(key)
        end
      end
    end
  end
end
