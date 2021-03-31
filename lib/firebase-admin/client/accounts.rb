require 'jwt'

module FirebaseAdmin
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
      #   FirebaseAdmin.create_account(
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
      #   FirebaseAdmin.update_account(
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
      #   FirebaseAdmin.sign_in_with_password(
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
      #   FirebaseAdmin.sign_in_with_custom_token("...")
      def sign_in_with_custom_token(token)
        post('v1/accounts:signInWithCustomToken', { token: token, returnSecureToken: true })
      end

      # Sign in based on the UID of an account
      # This generates a custom token for the UID and signs in using the custom token
      #
      # @param uid [String] The uid of a user
      #
      # @return [Resource] with idToken
      #
      # @example
      #   FirebaseAdmin.sign_in_for_uid("...")
      def sign_in_for_uid(uid)
        custom_token = create_custom_token(uid)
        sign_in_with_custom_token(custom_token)
      end

      # Create a custom JWT token for a UID
      #
      # @param uid [String] The uid of a user
      #
      # @return [String]
      # @see https://firebase.google.com/docs/reference/rest/auth
      #
      # @example
      #   FirebaseAdmin.create_custom_token('...')
      def create_custom_token(uid)
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
      #   FirebaseAdmin.get_user_by(:email, "lebron@lakers.com")
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
      #   FirebaseAdmin.reset()
      def reset
        delete("emulator/v1/projects/#{project_id}/accounts")
      end

      private

      def unescape(str)
        str = str.gsub '\n', "\n"
        str = str[1..-2] if str.start_with?('"') && str.end_with?('"')
        str
      end

      def service_account_email
        default_credentials.fetch('client_email') { ENV['GOOGLE_CLIENT_EMAIL'] }
      end

      def private_key
        key = default_credentials.fetch('private_key') { unescape(ENV['GOOGLE_PRIVATE_KEY']) }
        OpenSSL::PKey::RSA.new(key)
      end

      def default_credentials
        @default_credentials ||= begin
          credentials_path = ENV['GOOGLE_APPLICATION_CREDENTIALS']
          JSON.parse(File.read(credentials_path)) if credentials_path
        end
      end
    end
  end
end
