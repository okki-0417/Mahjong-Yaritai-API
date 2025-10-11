# frozen_string_literal: true

module Resolvers
  class LearningQuestionsResolver < BaseResolver
    type [ Types::LearningQuestionType ], null: false
    description "Get learning questions by category"

    argument :learning_category_id, ID, required: true

    def resolve(learning_category_id:)
      LearningQuestion.includes(:learning_category).where(learning_category_id: learning_category_id)
    end
  end
end
