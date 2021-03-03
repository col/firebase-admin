require 'faraday'
require File.expand_path('version', __dir__)

module FirebaseAuth
  # Defines constants and methods related to configuration
  module Configuration
    # An array of valid keys in the options hash when configuring a {FirebaseAuth::API}
    VALID_OPTIONS_KEYS = %i[
      access_token
      adapter
      connection_options
      endpoint
      user_agent
      project_id
      loud_logger
    ].freeze

    # By default, don't set a user access token
    DEFAULT_ACCESS_TOKEN = 'owner'.freeze

    # The adapter that will be used to connect if none is set
    #
    # @note The default faraday adapter is Net::HTTP.
    DEFAULT_ADAPTER = Faraday.default_adapter

    # By default, don't set any connection options
    DEFAULT_CONNECTION_OPTIONS = {}.freeze

    # The endpoint that will be used to connect if none is set
    #
    # @note There is no reason to use any other endpoint at this time
    DEFAULT_ENDPOINT = 'https://identitytoolkit.googleapis.com/'.freeze

    # The response format appended to the path and sent in the 'Accept' header if none is set
    #
    # @note JSON is the only available format at this time
    DEFAULT_FORMAT = :json

    # The user agent that will be sent to the API endpoint if none is set
    DEFAULT_USER_AGENT = "Firebase Auth Ruby Gem #{FirebaseAuth::VERSION}".freeze

    # TODO: ...
    DEFAULT_PROJECT_ID = ''.freeze

    # By default, don't turn on loud logging
    DEFAULT_LOUD_LOGGER = nil

    # @private
    attr_accessor(*VALID_OPTIONS_KEYS)

    # When this module is extended, set all configuration options to their default values
    def self.extended(base)
      base.reset
    end

    # Convenience method to allow configuration options to be set in a block
    def configure
      yield self
    end

    # Create a hash of options and their values
    def options
      VALID_OPTIONS_KEYS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    # Reset all configuration options to defaults
    def reset
      self.access_token       = DEFAULT_ACCESS_TOKEN
      self.adapter            = DEFAULT_ADAPTER
      self.connection_options = DEFAULT_CONNECTION_OPTIONS
      self.endpoint           = DEFAULT_ENDPOINT
      self.user_agent         = DEFAULT_USER_AGENT
      self.project_id         = DEFAULT_PROJECT_ID
      self.loud_logger        = DEFAULT_LOUD_LOGGER
    end
  end
end
