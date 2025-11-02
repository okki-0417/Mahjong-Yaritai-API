# frozen_string_literal: true

module Mutations
  module Auth
    class Logout < BaseMutation
      include Authenticatable

      description "Logout current user"

      field :success, Boolean, null: false

      def resolve
        require_authentication!

        logout

        { success: true }
      end
    end
  end
end
