module Auth
  module Google
    class LoginsController < ApplicationController
      def show
        google_auth_url = build_google_auth_url
        render json: { redirect_url: google_auth_url }, status: :ok
      end

      private

        def build_google_auth_url
          client_id = ENV["GOOGLE_CLIENT_ID"]
          redirect_uri = ENV["GOOGLE_REDIRECT_URI"]

          params = {
            client_id: client_id,
            redirect_uri: redirect_uri,
            response_type: "code",
            scope: "openid email profile",
            access_type: "offline",
            prompt: "consent",
          }

          "https://accounts.google.com/o/oauth2/v2/auth?#{params.to_query}"
        end
    end
  end
end
