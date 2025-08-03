class Learning::QuestionSerializer < ActiveModel::Serializer
  attributes :id, :statement, :answer, :created_at, :updated_at

  belongs_to :category, serializer: Learning::CategorySerializer
end
