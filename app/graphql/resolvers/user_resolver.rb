# frozen_string_literal: true

module Resolvers
  class UserResolver < BaseResolver
    type Types::UserType, null: true

    argument :id, ID, required: true

    def resolve(id:)
      User.find_by(id: id)
    end
  end
end
