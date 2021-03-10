require File.expand_path('spec_helper', __dir__)

describe FirebaseAdmin do
  after do
    FirebaseAdmin.reset
  end

  context 'when delegating to a client' do
    before do
      FirebaseAdmin.project_id = 'test-project'

      stub_post('v1/projects/test-project/accounts')
        .to_return(body: fixture('create_account.json'), headers: { content_type: 'application/json; charset=utf-8' })
    end

    it 'should get the correct resource' do
      FirebaseAdmin.create_account({})
      expect(a_post('v1/projects/test-project/accounts')).to have_been_made
    end

    it 'should return the same results as a client' do
      expect(FirebaseAdmin.create_account({})).to eq(FirebaseAdmin::Client.new.create_account({}))
    end
  end

  describe '.client' do
    it 'should be a FirebaseAdmin::Client' do
      expect(FirebaseAdmin.client).to be_a FirebaseAdmin::Client
    end
  end

  describe '.adapter' do
    it 'should return the default adapter' do
      expect(FirebaseAdmin.adapter).to eq(FirebaseAdmin::Configuration::DEFAULT_ADAPTER)
    end
  end

  describe '.adapter=' do
    it 'should set the adapter' do
      FirebaseAdmin.adapter = :typhoeus
      expect(FirebaseAdmin.adapter).to eq(:typhoeus)
    end
  end

  describe '.endpoint' do
    it 'should return the default endpoint' do
      expect(FirebaseAdmin.endpoint).to eq(FirebaseAdmin::Configuration::DEFAULT_ENDPOINT)
    end
  end

  describe '.endpoint=' do
    it 'should set the endpoint' do
      FirebaseAdmin.endpoint = 'http://tumblr.com'
      expect(FirebaseAdmin.endpoint).to eq('http://tumblr.com')
    end
  end

  describe '.user_agent' do
    it 'should return the default user agent' do
      expect(FirebaseAdmin.user_agent).to eq(FirebaseAdmin::Configuration::DEFAULT_USER_AGENT)
    end
  end

  describe '.user_agent=' do
    it 'should set the user_agent' do
      FirebaseAdmin.user_agent = 'Custom User Agent'
      expect(FirebaseAdmin.user_agent).to eq('Custom User Agent')
    end
  end

  describe '.loud_logger' do
    it 'should return the loud_logger status' do
      expect(FirebaseAdmin.loud_logger).to be_nil
    end
  end

  describe '.loud_logger=' do
    it 'should set the loud_logger' do
      FirebaseAdmin.loud_logger = true
      expect(FirebaseAdmin.loud_logger).to be_truthy
    end
  end

  describe '.configure' do
    FirebaseAdmin::Configuration::VALID_OPTIONS_KEYS.each do |key|
      it "should set the #{key}" do
        FirebaseAdmin.configure do |config|
          config.send("#{key}=", key)
          expect(FirebaseAdmin.send(key)).to eq(key)
        end
      end
    end
  end
end
