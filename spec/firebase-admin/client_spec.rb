require File.expand_path('../spec_helper', __dir__)

describe FirebaseAdmin::Client do
  it 'should connect using the endpoint configuration' do
    expected_endpoint = 'http://example.com/'
    client = FirebaseAdmin::Client.new(endpoint: expected_endpoint)
    actual_endpoint = client.send(:connection).build_url(nil).to_s
    expect(actual_endpoint).to eq(expected_endpoint.to_s)
  end
end
