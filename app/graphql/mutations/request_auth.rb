# frozen_string_literal: true

module Mutations
  class RequestAuth < BaseMutation
    description "Request authentication by sending email with verification code"

    field :success, Boolean, null: false
    field :errors, [ String ], null: false
    field :message, String, null: true

    argument :email, String, required: true

    def resolve(email:)
      auth_request = AuthRequest.new(email: email)

      if auth_request.save
        AuthorizationMailer.send_authorization_link(auth_request).deliver_now
        {
          success: true,
          errors: [],
          message: "Authentication token sent to your email"
        }
      else
        {
          success: false,
          errors: auth_request.errors.full_messages,
          message: nil
        }
      end
    rescue StandardError => e
      Rails.logger.error "RequestAuth mutation error: #{e.message}"
      {
        success: false,
        errors: [ "System error occurred" ],
        message: nil
      }
    end
  end
end
