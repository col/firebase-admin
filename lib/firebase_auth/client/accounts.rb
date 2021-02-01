module FirebaseAuth
  class Client
    # Defines methods related to accounts
    module Accounts
      # Create a new account
      #
      # @param params [Hash] A customizable set of params
      # @option options [String] :email
      # @option options [String] :password
      # @option options [String] :phoneNumber
      # @option options [String] :displayName
      # @option options [String] :photoUrl
      # @option options [String] :customAttributes
      # @option customAttributes [String] :roles
      #
      # @return [Resource]
      # @see https://firebase.google.com/docs/reference/rest/auth#section-create-email-password
      #
      # @example
      #   FirebaseAuth.create_account(
      #     :email => "lebron@lakers.com",
      #     :password => "supersecret",
      #     :phoneNumber => "+5555555555",
      #     :displayName => "LeBron James"
      #     :photoUrl => "http://www.example.com/photo.jpg"
      #     :customAttributes => {
      #       :roles => ['admin']
      #     },
      # )
      def create_account(params)
        post("v1/projects/#{project_id}/accounts", params)
      end
    end
  end
end
