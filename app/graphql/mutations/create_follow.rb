# frozen_string_literal: true

module Mutations
  class CreateFollow < BaseMutation
    description "Follow a user"

    argument :user_id, ID, required: true

    field :success, Boolean, null: false
    field :errors, [ String ], null: true

    def resolve(user_id:)
      raise GraphQL::ExecutionError, "User must be logged in" unless context[:current_user]

      follow = context[:current_user].active_follows.new(
        followee_id: user_id
      )

      raise GraphQL::ExecutionError, follow.errors.full_messages.join(", ") unless follow.save

        { success: true, errors: [] }
    end
  end
end
