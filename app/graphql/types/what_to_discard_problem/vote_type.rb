# frozen_string_literal: true

module Types
  class WhatToDiscardProblem::VoteType < Types::BaseObject
    field :id, ID, null: false
    field :user_id, Integer, null: false
    field :tile_id, Integer, null: false
    field :what_to_discard_problem_id, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :tile, Types::TileType, null: false
  end
end
