require File.expand_path('../../spec_helper', __dir__)

describe FirebaseAuth::Client do
  before do
    @client = FirebaseAuth::Client.new(project_id: 'test-project')
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
end
