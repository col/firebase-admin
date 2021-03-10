require 'addressable/uri'
require 'json'

module FirebaseAdmin
  # Defines HTTP request methods
  module Request
    # Perform an HTTP GET request
    def get(path, options = {})
      request(:get, path, options)
    end

    # Perform an HTTP POST request
    def post(path, options = {})
      request(:post, path, options)
    end

    # Perform an HTTP PUT request
    def put(path, options = {})
      request(:put, path, options)
    end

    # Perform an HTTP DELETE request
    def delete(path, options = {})
      request(:delete, path, options)
    end

    private

    # Perform an HTTP request
    def request(method, path, options)
      response = connection.send(method) do |request|
        case method
        when :post, :put
          request.path = Addressable::URI.escape(path)
          request.body = options.to_json unless options.empty?

        else
          request.url(Addressable::URI.escape(path), options)
        end
      end
      response.body
    end
  end
end
