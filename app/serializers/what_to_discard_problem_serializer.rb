# frozen_string_literal: true

class WhatToDiscardProblemSerializer < ActiveModel::Serializer
  attributes %i[
    id
    round
    turn
    wind
    point_east
    point_south
    point_west
    point_north
    user_id
    dora_id
    hand1_id
    hand2_id
    hand3_id
    hand4_id
    hand5_id
    hand6_id
    hand7_id
    hand8_id
    hand9_id
    hand10_id
    hand11_id
    hand12_id
    hand13_id
    tsumo_id
    comments_count
    likes_count
    votes_count
    created_at
    updated_at
  ]

  belongs_to :user, serializer: UserSerializer
  belongs_to :dora, serializer: TileSerializer
  belongs_to :hand1, serializer: TileSerializer
  belongs_to :hand2, serializer: TileSerializer
  belongs_to :hand3, serializer: TileSerializer
  belongs_to :hand4, serializer: TileSerializer
  belongs_to :hand5, serializer: TileSerializer
  belongs_to :hand6, serializer: TileSerializer
  belongs_to :hand7, serializer: TileSerializer
  belongs_to :hand8, serializer: TileSerializer
  belongs_to :hand9, serializer: TileSerializer
  belongs_to :hand10, serializer: TileSerializer
  belongs_to :hand11, serializer: TileSerializer
  belongs_to :hand12, serializer: TileSerializer
  belongs_to :hand13, serializer: TileSerializer
  belongs_to :tsumo, serializer: TileSerializer
end
