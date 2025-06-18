# frozen_string_literal: true

class Loaders::RecordLoader < GraphQL::Dataloader::Source
  def initialize(model, column: :id)
    @model = model
    @column = column
  end

  def fetch(keys)
    @model.where(@column => keys).index_by(&@column).values_at(*keys)
  end
end
