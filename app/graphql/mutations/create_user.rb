module Mutations
  class CreateUser < BaseMutation
    field :user, Types::UserType, null: true
    field :errors, [ String ], null: false

    argument :name, String, required: true
    argument :email, String, required: true
    argument :avatar, GraphQL::Types::String, required: false

    def resolve(name:, email:, avatar: nil)
      user = User.new(name: name, email: email)
      user.avatar.attach(avatar) if avatar

      if user.save
        { user: user, errors: [] }
      else
        { user: nil, errors: user.errors.full_messages }
      end
    end
  end
end
