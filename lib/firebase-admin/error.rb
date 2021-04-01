module FirebaseAdmin
  # Custom error class for rescuing from all Firebase errors
  class Error < StandardError; end

  # Raised when Firebase returns the HTTP status code 400
  class BadRequest < Error; end

  # Raised when Firebase returns the HTTP status code 404
  class NotFound < Error; end

  # Raised when Firebase returns the HTTP status code 429
  class TooManyRequests < Error; end

  # Raised when Firebase returns the HTTP status code 500
  class InternalServerError < Error; end

  # Raised when Firebase returns the HTTP status code 502
  class BadGateway < Error; end

  # Raised when Firebase returns the HTTP status code 503
  class ServiceUnavailable < Error; end

  # Raised when Firebase returns the HTTP status code 504
  class GatewayTimeout < Error; end

  # Raised when Firebase returns the HTTP status code 429
  class RateLimitExceeded < Error; end

  # Raised when no valid credentials are found
  class InvalidCredentials < Error; end
end
