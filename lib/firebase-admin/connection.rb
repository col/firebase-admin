require 'faraday_middleware'
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
        connection.authorization :Bearer, access_token if access_token
        connection.use Faraday::Request::UrlEncoded
        connection.use FaradayMiddleware::Mashify
        connection.use Faraday::Response::ParseJson
        connection.use FaradayMiddleware::RaiseHttpException
        connection.use FaradayMiddleware::LoudLogger if loud_logger
        connection.adapter(adapter)
      end
    end
  end
end
