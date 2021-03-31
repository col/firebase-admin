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

  describe '.sign_in_for_uid' do
    it 'should post to the  update endpoint' do
      expect(@client).to receive(:create_custom_token).with('user-123').and_return('token')
      expect(@client).to receive(:sign_in_with_custom_token).with('token').and_return('result')
      result = @client.sign_in_for_uid('user-123')
      expect(result).to eq('result')
    end
  end
end
