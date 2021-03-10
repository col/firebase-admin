require File.expand_path('firebase-admin/error', __dir__)
require File.expand_path('firebase-admin/configuration', __dir__)
require File.expand_path('firebase-admin/api', __dir__)
require File.expand_path('firebase-admin/client', __dir__)

module FirebaseAdmin
  extend Configuration

  # Alias for FirebaseAdmin::Client.new
  #
  # @return [FirebaseAdmin::Client]
  def self.client(options = {})
    FirebaseAdmin::Client.new(options)
  end

  # Delegate to FirebaseAdmin::Client
  def self.method_missing(method, *args, &block)
    return super unless client.respond_to?(method)

    client.send(method, *args, &block)
  end

  # Delegate to FirebaseAdmin::Client
  def self.respond_to_missing?(method, include_all)
    client.respond_to_missing?(method, include_all) || super
  end

  # Delegate to FirebaseAdmin::Client
  def self.respond_to?(method, include_all)
    client.respond_to?(method, include_all) || super
  end
end
