# frozen_string_literal: true

module Mutations
  module WhatToDiscardProblems
    module Likes
      class Delete < BaseMutation
        graphql_name "DeleteWhatToDiscardProblemLike"

        include Authenticatable

        field :id, ID, null: false

        argument :what_to_discard_problem_id, ID, required: true

        def resolve(what_to_discard_problem_id:)
          raise GraphQL::ExecutionError, "ログインしてください" unless logged_in?

          problem = WhatToDiscardProblem.find(what_to_discard_problem_id)
          like = context[:current_user].created_likes.find_by!(likable: problem)
          like_id = like.id

          if like.destroy
            { id: like_id }
          else
            like.errors.full_messages.each do |message|
              context.add_error(GraphQL::ExecutionError.new(message))
            end
            nil
          end
        end
      end
    end
  end
end
