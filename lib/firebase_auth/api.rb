require File.expand_path('connection', __dir__)
require File.expand_path('request', __dir__)

module FirebaseAuth
  # @private
  class API
    # @private
    attr_accessor(*Configuration::VALID_OPTIONS_KEYS)

    # Creates a new API
    def initialize(options = {})
      options = FirebaseAuth.options.merge(options)
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end

    def config
      conf = {}
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        conf[key] = send key
      end
      conf
    end

    include Connection
    include Request
  end
end
