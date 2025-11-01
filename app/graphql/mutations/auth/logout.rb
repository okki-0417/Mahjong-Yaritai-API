# frozen_string_literal: true

module Mutations
  module Auth
    class Logout < BaseMutation
      include Authenticatable

      description "Logout current user"

      field :success, Boolean, null: false

      def resolve
        raise GraphQL::ExecutionError, "ログインしてください" unless logged_in?

        Rails.logger.debug "=== Logout Mutation START ==="
        Rails.logger.debug "Before logout - Session: #{context[:session].to_hash.inspect}"
        Rails.logger.debug "Before logout - Session object_id: #{context[:session].object_id}"
        Rails.logger.debug "Before logout - Cookies user_id: #{context[:cookies]&.signed&.[](:user_id)}"
        Rails.logger.debug "Before logout - Cookies remember_token: #{context[:cookies]&.signed&.[](:remember_token)}"

        logout

        Rails.logger.debug "After logout - Session: #{context[:session].to_hash.inspect}"
        Rails.logger.debug "After logout - Session object_id: #{context[:session].object_id}"
        Rails.logger.debug "After logout - Cookies user_id: #{context[:cookies]&.signed&.[](:user_id)}"
        Rails.logger.debug "After logout - Cookies remember_token: #{context[:cookies]&.signed&.[](:remember_token)}"
        Rails.logger.debug "=== Logout Mutation END ==="

        { success: true }
      end
    end
  end
end
