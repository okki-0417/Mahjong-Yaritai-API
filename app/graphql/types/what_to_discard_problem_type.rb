# frozen_string_literal: true

module Types
  class WhatToDiscardProblemType < Types::BaseObject
    field :id, ID, null: false
    field :user_id, Integer, null: false
    field :user, Types::UserType, null: false
    field :round, String, null: false
    field :turn, Integer, null: false
    field :wind, String, null: false
    field :point_east, Integer, null: false
    field :point_south, Integer, null: false
    field :point_west, Integer, null: false
    field :point_north, Integer, null: false
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
    field :likes_count, Int, null: false
    field :comments_count, Int, null: false
    field :votes_count, Int, null: false
    field :my_like, Types::WhatToDiscardProblem::LikeType
    field :my_vote, Types::WhatToDiscardProblem::VoteType
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def my_like
      object = self.object
      object.likes.find_by(user_id: context[:current_user]&.id)
    end

    def my_vote
      object = self.object
      object.votes.find_by(user_id: context[:current_user]&.id)
    end
  end
end
