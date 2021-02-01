require 'faraday'

# @private
module FaradayMiddleware
  # @private
  class RaiseHttpException < Faraday::Middleware
    def call(env)
      @app.call(env).on_complete do |response|
        case response[:status].to_i
        when 400
          raise FirebaseAuth::BadRequest,
                error_message_400(response)
        when 404
          raise FirebaseAuth::NotFound,
                error_message_400(response)
        when 429
          raise FirebaseAuth::TooManyRequests,
                error_message_400(response)
        when 500
          raise FirebaseAuth::InternalServerError,
                error_message_500(response, 'Something is technically wrong.')
        when 502
          raise FirebaseAuth::BadGateway,
                error_message_500(response, 'The server returned an invalid or incomplete response.')
        when 503
          raise FirebaseAuth::ServiceUnavailable,
                error_message_500(response, 'FirebaseAuth is rate limiting your requests.')
        when 504
          raise FirebaseAuth::GatewayTimeout,
                error_message_500(response, '504 Gateway Time-out')
        end
      end
    end

    def initialize(app)
      super app
      @parser = nil
    end

    private

    def error_message_400(response)
      "#{response[:method].to_s.upcase} #{response[:url]}: #{response[:status]}#{error_body(response[:body])}"
    end

    def error_body(body)
      # body gets passed as a string, not sure if it is passed as something else from other spots?
      body = ::JSON.parse(body) if !body.nil? && !body.empty? && body.is_a?(String)

      if body.nil?
        nil
      elsif body['error'] && body['error']['message'] && !body['error']['message'].empty?
        ": #{body['error']['message']}"
      end
    end

    def error_message_500(response, body = nil)
      "#{response[:method].to_s.upcase} #{response[:url]}: #{response[:status]}: #{body}"
    end
  end
end
