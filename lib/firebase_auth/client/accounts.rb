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
      #     :password => "super-secret",
      #     :phoneNumber => "+5555555555",
      #     :displayName => "LeBron James",
      #     :photoUrl => "http://www.example.com/photo.jpg",
      #     :customAttributes => {
      #       :roles => ['admin']
      #     }
      # )
      def create_account(params)
        post("v1/projects/#{project_id}/accounts", params)
      end

      # Update an existing account
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
      # @see https://firebase.google.com/docs/reference/rest/auth
      #
      # @example
      #   FirebaseAuth.update_account(
      #     email: "lebron@lakers.com",
      #     password: "super-secret",
      #     phoneNumber: "+5555555555",
      #     displayName: "LeBron James",
      #     photoUrl: "http://www.example.com/photo.jpg",
      #     localId: "1234",
      #     customAttributes: {
      #       :roles => ['admin']
      #     }
      # )
      def update_account(params)
        post("v1/projects/#{project_id}/accounts:update", params)
      end

      # Sign in with a password
      #
      # @param params [Hash] A customizable set of params
      # @option options [String] :email
      # @option options [String] :password
      #
      # @return [Resource]
      # @see https://firebase.google.com/docs/reference/rest/auth
      #
      # @example
      #   FirebaseAuth.sign_in_with_password(
      #     email: "lebron@lakers.com",
      #     password: "super-secret"
      # )
      def sign_in(params)
        post('v1/accounts:signInWithPassword', params)
      end

      # Reset emulator
      #
      # @return [Resource]
      # @see https://firebase.google.com/docs/reference/rest/auth
      #
      # @example
      #   FirebaseAuth.reset()
      def reset
        delete("emulator/v1/projects/#{project_id}/accounts")
      end
    end
  end
end
