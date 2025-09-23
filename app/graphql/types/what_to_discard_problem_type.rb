# frozen_string_literal: true

module Types
  class WhatToDiscardProblemType < Types::BaseObject
    field :id, ID, null: false
    field :round, String, null: true
    field :turn, Integer, null: true
    field :wind, String, null: true
    field :points, String, null: true
    field :description, String, null: true
    field :user, Types::UserType, null: false

    field :votes_count, Integer, null: false
    field :comments_count, Integer, null: false
    field :likes_count, Integer, null: false

    field :dora, Types::TileType, null: false
    field :hand1, Types::TileType, null: false
    field :hand2, Types::TileType, null: false
    field :hand3, Types::TileType, null: false
    field :hand4, Types::TileType, null: false
    field :hand5, Types::TileType, null: false
    field :hand6, Types::TileType, null: false
    field :hand7, Types::TileType, null: false
    field :hand8, Types::TileType, null: false
    field :hand9, Types::TileType, null: false
    field :hand10, Types::TileType, null: false
    field :hand11, Types::TileType, null: false
    field :hand12, Types::TileType, null: false
    field :hand13, Types::TileType, null: false
    field :tsumo, Types::TileType, null: false

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
