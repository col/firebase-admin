require 'jwt'

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
      def sign_in_with_password(params)
        post('v1/accounts:signInWithPassword', params)
      end

      # Sign in with custom token
      #
      # @param token [String] A custom token
      #
      # @return [Resource] with idToken
      #
      # @example
      #   FirebaseAuth.sign_in_with_custom_token("...")
      def sign_in_with_custom_token(token)
        post('v1/accounts:signInWithCustomToken', { token: token, returnSecureToken: true })
      end

      # Create a custom JWT token for a UID
      #
      # @param uid [String] The uid of a user
      #
      # @return [String]
      # @see https://firebase.google.com/docs/reference/rest/auth
      #
      # @example
      #   FirebaseAuth.create_custom_token('...')
      def create_custom_token(uid)
        credentials = JSON.parse(File.read(ENV['GOOGLE_ACCOUNT_CREDENTIALS']))

        service_account_email = credentials['client_email']
        private_key = OpenSSL::PKey::RSA.new credentials['private_key']

        now_seconds = Time.now.to_i
        payload = {
          iss: service_account_email,
          sub: service_account_email,
          aud: 'https://identitytoolkit.googleapis.com/google.identity.identitytoolkit.v1.IdentityToolkit',
          iat: now_seconds,
          exp: now_seconds + (60 * 60), # Maximum expiration time is one hour
          uid: uid
        }
        JWT.encode(payload, private_key, 'RS256')
      end

      # Get user by email/phone/uid
      #
      # @param key [String] either :email or :phone
      # @param value [String] the value to search for
      #
      # @return [Resource]
      #
      # @example
      #   FirebaseAuth.get_user_by(:email, "lebron@lakers.com")
      def get_user_by(key, value)
        params = {}
        params[key] = Array(value)
        response = post('v1/accounts:lookup', params)
        (response[:users] || []).first
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
