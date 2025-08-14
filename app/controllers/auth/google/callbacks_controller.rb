module Auth
  module Google
    class CallbacksController < ApplicationController
      def create
        code = params[:code]

        if code.blank?
          return render json: error_json([ "Authorization code is missing" ]), status: :bad_request
        end

        # Exchange authorization code for access token
        token_response = exchange_code_for_token(code)

        if token_response[:error]
          return render json: error_json([ token_response[:error] ]), status: :unprocessable_entity
        end

        # Get user info from Google
        user_info = fetch_google_user_info(token_response[:access_token])

        if user_info[:error]
          return render json: error_json([ user_info[:error] ]), status: :unprocessable_entity
        end

        # Find or create user
        user = User.find_by(email: user_info[:email])

        if user
          # User exists, log them in
          login user
          remember user

          render json: user,
            serializer: SessionSerializer,
            root: :session,
            status: :ok
        else
          # User doesn't exist, create auth request
          # This will be used to complete the registration process
          auth_request = AuthRequest.new(email: user_info[:email])

          if auth_request.save
            session[:auth_request_id] = auth_request.id
            render body: nil, status: :no_content
          else
            render json: validation_error_json(auth_request), status: :unprocessable_entity
          end
        end
      end

      private

        def exchange_code_for_token(code)
          uri = URI("https://oauth2.googleapis.com/token")
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true

          request = Net::HTTP::Post.new(uri)
          request["Content-Type"] = "application/x-www-form-urlencoded"
          request.body = URI.encode_www_form({
            client_id: ENV["GOOGLE_CLIENT_ID"],
            client_secret: ENV["GOOGLE_CLIENT_SECRET"],
            code:,
            redirect_uri: ENV["GOOGLE_REDIRECT_URI"],
            grant_type: "authorization_code",
          })

          response = http.request(request)

          if response.code == "200"
            data = JSON.parse(response.body)
            { access_token: data["access_token"], id_token: data["id_token"] }
          else
            Rails.logger.info(JSON.parse(response.body))
            { error: "Failed to exchange code for token" }
          end
        rescue => e
          { error: e.message }
        end

      def fetch_google_user_info(access_token)
        uri = URI("https://www.googleapis.com/oauth2/v2/userinfo")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new(uri)
        request["Authorization"] = "Bearer #{access_token}"

        response = http.request(request)

        if response.code == "200"
          data = JSON.parse(response.body)
          { email: data["email"] }
        else
          { error: "Failed to fetch user info" }
        end
      rescue => e
        { error: e.message }
      end
    end
  end
end
