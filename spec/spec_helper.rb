begin
  require 'simplecov'
rescue LoadError
  # ignore
else
  SimpleCov.start do
    add_group 'FirebaseAdmin', 'lib/firebase-admin'
    add_group 'Faraday Middleware', 'lib/faraday'
    add_group 'Specs', 'spec'
  end
end

require File.expand_path('../lib/firebase-admin', __dir__)

require 'rspec'
require 'webmock/rspec'

RSpec.configure do |config|
  config.include WebMock::API
end

def capture_output(&block)
  begin
    old_stdout = $stdout
    $stdout = StringIO.new
    block.call
    result = $stdout.string
  ensure
    $stdout = old_stdout
  end
  result
end

def a_delete(path)
  a_request(:delete, FirebaseAdmin.endpoint + path)
end

def a_get(path)
  a_request(:get, FirebaseAdmin.endpoint + path)
end

def a_post(path)
  a_request(:post, FirebaseAdmin.endpoint + path)
end

def a_put(path)
  a_request(:put, FirebaseAdmin.endpoint + path)
end

def stub_delete(path)
  stub_request(:delete, FirebaseAdmin.endpoint + path)
end

def stub_get(path)
  stub_request(:get, FirebaseAdmin.endpoint + path)
end

def stub_post(path)
  stub_request(:post, FirebaseAdmin.endpoint + path)
end

def stub_put(path)
  stub_request(:put, FirebaseAdmin.endpoint + path)
end

def fixture_path
  File.expand_path('fixtures', __dir__)
end

def fixture(file)
  File.new("#{fixture_path}/#{file}")
end
