require File.expand_path('firebase_auth/error', __dir__)
require File.expand_path('firebase_auth/configuration', __dir__)
require File.expand_path('firebase_auth/api', __dir__)
require File.expand_path('firebase_auth/client', __dir__)
require File.expand_path('firebase_auth/response', __dir__)

module FirebaseAuth
  extend Configuration

  # Alias for FirebaseAuth::Client.new
  #
  # @return [FirebaseAuth::Client]
  def self.client(options = {})
    FirebaseAuth::Client.new(options)
  end

  # Delegate to FirebaseAuth::Client
  def self.method_missing(method, *args, &block)
    return super unless client.respond_to?(method)

    client.send(method, *args, &block)
  end

  # Delegate to FirebaseAuth::Client
  def self.respond_to_missing?(method, include_all)
    client.respond_to_missing?(method, include_all) || super
  end

  # Delegate to FirebaseAuth::Client
  def self.respond_to?(method, include_all)
    client.respond_to?(method, include_all) || super
  end
end
