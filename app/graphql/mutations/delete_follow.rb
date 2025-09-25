# frozen_string_literal: true

module Mutations
  class DeleteFollow < BaseMutation
    description "Unfollow a user"

    argument :user_id, ID, required: true

    field :success, Boolean, null: false
    field :errors, [ String ], null: true

    def resolve(user_id:)
      raise GraphQL::ExecutionError, "User must be logged in" unless context[:current_user]

      follow = context[:current_user].active_follows.find_by(
        followee_id: user_id
      )

      if follow.nil?
        { success: false, errors: [ "Follow not found" ] }
      elsif follow.destroy
        { success: true, errors: [] }
      else
        { success: false, errors: follow.errors.full_messages }
      end
    end
  end
end