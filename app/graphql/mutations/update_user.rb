module Mutations
  class UpdateUser < BaseMutation
    field :user, Types::UserType, null: true
    field :errors, [String], null: false

    argument :name, String, required: false
    argument :avatar, GraphQL::Types::String, required: false

    def resolve(**attributes)
      return { user: nil, errors: ["ログインが必要です"] } unless context[:current_user]

      user = context[:current_user]

      if user.update(attributes)
        { user: user, errors: [] }
      else
        { user: nil, errors: user.errors.full_messages }
      end
    end
  end
end