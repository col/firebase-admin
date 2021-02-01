module FirebaseAuth
  # Wrapper for the Firebase Auth REST API
  #
  # @note All methods have been separated into modules and follow the same grouping used in http://???
  # @see http://???
  class Client < API
    Dir[File.expand_path('client/*.rb', __dir__)].sort.each { |f| require f }

    include FirebaseAuth::Client::Accounts
  end
end
