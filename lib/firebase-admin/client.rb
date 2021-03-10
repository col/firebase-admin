module FirebaseAdmin
  # Wrapper for the Firebase Admin REST API
  #
  # @note All methods have been separated into modules and follow the same grouping used in http://???
  # @see http://???
  class Client < API
    Dir[File.expand_path('client/*.rb', __dir__)].sort.each { |f| require f }

    include FirebaseAdmin::Client::Accounts
  end
end
