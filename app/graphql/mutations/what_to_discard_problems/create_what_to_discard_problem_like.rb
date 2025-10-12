# frozen_string_literal: true

module Mutations
  module WhatToDiscardProblems
    class CreateWhatToDiscardProblemLike < BaseMutation
      include Authenticatable

      field :like, Types::LikeType, null: false

      argument :problem_id, ID, required: true

      def resolve(problem_id:)
        raise GraphQL::ExecutionError, "ログインしてください" unless logged_in?

        problem = WhatToDiscardProblem.find(problem_id)

        like = context[:current_user].created_likes.new(likable: problem)

        if like.save
          { like: }
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
