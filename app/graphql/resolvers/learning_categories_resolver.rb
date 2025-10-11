# frozen_string_literal: true

module Resolvers
  class LearningCategoriesResolver < BaseResolver
    type [ Types::LearningCategoryType ], null: false
    description "Get all learning categories"

    def resolve
      LearningCategory.includes(:learning_questions)
    end
  end
end
