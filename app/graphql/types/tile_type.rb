# frozen_string_literal: true

module Types
  class TileType < Types::BaseObject
    field :id, ID, null: false
    field :suit, Integer, null: false
    field :ordinal_number_in_suit, Integer, null: false
    field :name, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
