module Types
  class WhatToDiscardProblemVoteResultType < Types::BaseObject
    field :tile_id, ID, null: false
    field :count, Integer, null: false
    field :percentage, Float, null: false
    field :tile, Types::TileType, null: false

    def tile
      Tile.find(object[:tile_id])
    end

    def percentage
      total = object[:total_votes] || 0
      return 0.0 if total == 0
      (object[:count].to_f / total * 100).round(1)
    end
  end
end