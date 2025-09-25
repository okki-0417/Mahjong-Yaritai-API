module Types
  class LearningCategoryType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :description, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :questions, [ Types::LearningQuestionType ], null: false

    def questions
      object.learning_questions
    end
  end
end
