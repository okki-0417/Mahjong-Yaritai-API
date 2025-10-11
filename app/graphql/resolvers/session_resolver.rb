# frozen_string_literal: true

module Resolvers
  class SessionResolver < BaseResolver
    type Types::SessionType, null: false

    def resolve
      {
        is_logged_in: current_user.present?,
        user: current_user,
      }
    end
  end
end
