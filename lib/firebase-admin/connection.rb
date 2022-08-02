require 'faraday/mashify'
Dir[File.expand_path('../faraday/*.rb', __dir__)].sort.each { |f| require f }

module FirebaseAdmin
  # @private
  module Connection
    private

    def connection
      options = {
        headers: {
          'Content-Type' => 'application/json; charset=utf-8',
          'Accept' => 'application/json; charset=utf-8',
          'User-Agent' => user_agent
        },
        url: endpoint
      }.merge(connection_options)

      Faraday::Connection.new(options) do |connection|
        connection.request :authorization, 'Bearer', access_token if access_token
        connection.request :url_encoded
        connection.response :mashify
        connection.response :json
        connection.use :raise_http_exception
        connection.use :load_logger if loud_logger
        connection.adapter(adapter)
      end
    end
  end
end
