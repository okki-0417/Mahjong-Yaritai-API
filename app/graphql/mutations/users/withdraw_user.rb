# frozen_string_literal: true

module Mutations
  module Users
    class WithdrawUser < BaseMutation
      include Authenticatable

      field :success, Boolean, null: false

      def resolve
        raise GraphQL::ExecutionError, "ログインしてください" unless logged_in?

        user = context[:current_user]

        if user.destroy
          logout
          { success: true }
        else
          user.errors.full_messages.each do |message|
            context.add_error(GraphQL::ExecutionError.new(message))
          end
          nil
        end
      end
    end
  end
end
