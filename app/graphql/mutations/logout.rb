# frozen_string_literal: true

module Mutations
  class Logout < BaseMutation
    description "Logout current user"

    field :success, Boolean, null: false
    field :errors, [ String ], null: false

    def resolve
      if context[:current_user]
        context[:session].clear
        context[:current_user] = nil
        {
          success: true,
          errors: []
        }
      else
        {
          success: false,
          errors: [ "No user logged in" ]
        }
      end
    rescue StandardError => e
      Rails.logger.error "Logout mutation error: #{e.message}"
      {
        success: false,
        errors: [ "Logout failed" ]
      }
    end
  end
end
