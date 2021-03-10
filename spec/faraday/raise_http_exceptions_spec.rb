# frozen_string_literal: true

require File.expand_path('../spec_helper', __dir__)

describe Faraday::Response do
  before do
    @client = FirebaseAdmin::Client.new(project_id: 'test-project')
  end

  {
    400 => FirebaseAdmin::BadRequest,
    404 => FirebaseAdmin::NotFound,
    429 => FirebaseAdmin::TooManyRequests,
    500 => FirebaseAdmin::InternalServerError,
    503 => FirebaseAdmin::ServiceUnavailable
  }.each do |status, exception|
    context "when HTTP status is #{status}" do
      before do
        stub_post('v1/projects/test-project/accounts')
          .to_return(status: status)
      end

      it "should raise #{exception.name} error" do
        expect do
          @client.create_account({})
        end.to raise_error(exception)
      end
    end
  end

  context 'when a 400 is raised' do
    before do
      stub_post('v1/projects/test-project/accounts')
        .to_return(body: fixture('400_error.json'), status: 400)
    end

    it 'should return the body error message' do
      expect do
        @client.create_account({})
      end.to raise_error(FirebaseAdmin::BadRequest, /INVALID_PHONE_NUMBER : Invalid format\./)
    end
  end

  context 'when a 502 is raised with an HTML response' do
    before do
      stub_post('v1/projects/test-project/accounts').to_return(
        body: fixture('bad_gateway.html'),
        status: 502
      )
    end

    it 'should raise an FirebaseAdmin::BadGateway' do
      expect do
        @client.create_account({})
      end.to raise_error(FirebaseAdmin::BadGateway)
    end
  end

  context 'when a 504 is raised with an HTML response' do
    before do
      stub_post('v1/projects/test-project/accounts').to_return(
        body: fixture('gateway_timeout.html'),
        status: 504
      )
    end

    it 'should raise an FirebaseAdmin::GatewayTimeout' do
      expect do
        @client.create_account({})
      end.to raise_error(FirebaseAdmin::GatewayTimeout)
    end
  end
end
