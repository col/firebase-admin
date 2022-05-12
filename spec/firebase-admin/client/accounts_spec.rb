require File.expand_path('../../spec_helper', __dir__)

describe FirebaseAdmin::Client do
  before do
    @client = FirebaseAdmin::Client.new(project_id: 'test-project')
  end

  describe '.create_account' do
    before do
      stub_post('v1/projects/test-project/accounts')
        .to_return(body: fixture('create_account.json'), headers: { content_type: 'application/json; charset=utf-8' })
    end

    it 'should get the correct resource' do
      @client.create_account(email: 'john@smith.com', password: 'supersecret')
      expect(
        a_post('v1/projects/test-project/accounts')
          .with(body: { email: 'john@smith.com', password: 'supersecret' }.to_json)
          .with(headers: { 'Authorization' => 'Bearer owner' })
      ).to have_been_made
    end
  end

  describe '.update_account' do
    before do
      stub_post('v1/projects/test-project/accounts:update')
        .to_return(body: fixture('update_account.json'), headers: { content_type: 'application/json; charset=utf-8' })
    end

    it 'should post to the  update endpoint' do
      @client.update_account(email: 'john@smith.com', password: 'supersecret')
      expect(
        a_post('v1/projects/test-project/accounts:update')
          .with(body: { email: 'john@smith.com', password: 'supersecret' }.to_json)
          .with(headers: { 'Authorization' => 'Bearer owner' })
      ).to have_been_made
    end
  end

  describe '.delete_account' do
    before do
      stub_post('v1/projects/test-project/accounts:delete')
        .to_return(body: fixture('delete_account.json'), headers: { content_type: 'application/json; charset=utf-8' })
    end

    it 'should post to the  delete endpoint' do
      @client.delete_account('local-id')
      expect(
        a_post('v1/projects/test-project/accounts:delete')
          .with(body: { localId: 'local-id'}.to_json)
          .with(headers: { 'Authorization' => 'Bearer owner' })
      ).to have_been_made
    end
  end

  describe '.create_custom_token' do
    context 'when credentials are set via GOOGLE_APPLICATION_CREDENTIALS' do
      before do
        ENV['GOOGLE_APPLICATION_CREDENTIALS'] = fixture('google_credentials.json').path
      end

      it 'returns a valid JWT token' do
        token = @client.create_custom_token('user-123')
        token_data, _alg = JWT.decode(token, nil, false)
        expect(token_data['uid']).to eq('user-123')
      end
    end

    context 'when GOOGLE_APPLICATION_CREDENTIALS points to an invalid file' do
      before do
        ENV['GOOGLE_APPLICATION_CREDENTIALS'] = fixture('google_credentials_invalid.json').path
      end

      it 'raises an error' do
        expect { @client.create_custom_token('user-123') }.to raise_error FirebaseAdmin::InvalidCredentials
      end
    end

    context 'when credentials are set via GOOGLE_CLIENT_EMAIL / GOOGLE_PRIVATE_KEY' do
      let(:email) { 'example@example.com' }
      let(:private_key) { fixture('example_key').read }

      before do
        ENV['GOOGLE_APPLICATION_CREDENTIALS'] = nil
        ENV['GOOGLE_CLIENT_EMAIL'] = email
        ENV['GOOGLE_PRIVATE_KEY'] = private_key
      end

      it 'returns a valid JWT token' do
        token = @client.create_custom_token('user-123')
        token_data, _alg = JWT.decode(token, nil, false)
        expect(token_data['uid']).to eq('user-123')
      end
    end

    context 'when no credentials are provided' do
      before do
        ENV['GOOGLE_APPLICATION_CREDENTIALS'] = nil
        ENV['GOOGLE_CLIENT_EMAIL'] = nil
        ENV['GOOGLE_PRIVATE_KEY'] = nil
      end

      it 'raises an error' do
        expect { @client.create_custom_token('user-123') }.to raise_error FirebaseAdmin::InvalidCredentials
      end
    end
  end

  describe '.sign_in_for_uid' do
    it 'should post to the  update endpoint' do
      expect(@client).to receive(:create_custom_token).with('user-123').and_return('token')
      expect(@client).to receive(:sign_in_with_custom_token).with('token').and_return('result')
      result = @client.sign_in_for_uid('user-123')
      expect(result).to eq('result')
    end
  end
end
