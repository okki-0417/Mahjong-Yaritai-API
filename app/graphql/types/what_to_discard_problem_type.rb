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
    field :bookmarks_count, Integer, null: false

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

    # 認証関連のフィールド
    field :is_liked_by_me, Boolean, null: false
    field :is_bookmarked_by_me, Boolean, null: false
    field :my_vote, Types::WhatToDiscardProblemVoteType, null: true

    # 投票結果
    field :vote_results, [ Types::WhatToDiscardProblemVoteResultType ], null: false

    # コメント
    field :comments, [ Types::CommentType ], null: false do
      argument :parent_comment_id, ID, required: false
      argument :limit, Integer, required: false
      argument :cursor, String, required: false
    end

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def is_liked_by_me
      return false unless context[:current_user]

      object.likes.exists?(user: context[:current_user])
    end

    def is_bookmarked_by_me
      return false unless context[:current_user]

      object.bookmarks.exists?(user: context[:current_user])
    end

    def my_vote
      return nil unless context[:current_user]

      object.votes.find_by(user: context[:current_user])
    end

    def vote_results
      vote_counts = object.votes.group(:tile_id).count
      total_votes = object.votes_count

      vote_counts.map do |tile_id, count|
        {
          tile_id: tile_id,
          count: count,
          total_votes: total_votes,
        }
      end
    end

    def comments(parent_comment_id: nil, limit: 10, cursor: nil)
      scope = object.comments
      scope = scope.where(parent_comment_id: parent_comment_id)
      scope = scope.where("id > ?", cursor) if cursor
      scope.limit(limit).includes(:user)
    end
  end
end
