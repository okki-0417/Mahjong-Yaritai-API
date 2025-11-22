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

    field :dora_id, ID, null: false
    field :hand1_id, ID, null: false
    field :hand2_id, ID, null: false
    field :hand3_id, ID, null: false
    field :hand4_id, ID, null: false
    field :hand5_id, ID, null: false
    field :hand6_id, ID, null: false
    field :hand7_id, ID, null: false
    field :hand8_id, ID, null: false
    field :hand9_id, ID, null: false
    field :hand10_id, ID, null: false
    field :hand11_id, ID, null: false
    field :hand12_id, ID, null: false
    field :hand13_id, ID, null: false
    field :tsumo_id, ID, null: false

    field :my_vote_tile_id, ID, null: true

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def my_vote_tile_id
      return nil unless context[:current_user]

      object.votes.find { |vote| vote.voted_by?(context[:current_user]) }&.tile_id
    end
  end
end
