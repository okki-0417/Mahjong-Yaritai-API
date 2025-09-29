module Types
  class WhatToDiscardProblemVoteResultType < Types::BaseObject
    field :tile_id, ID, null: false
    field :count, Integer, null: false
    field :percentage, Float, null: false
    field :tile, Types::TileType, null: false

    def tile
      # 改良されたTileSourceを使用してN+1を防ぐ
      object[:tile] || dataloader.with(Sources::TileSource).load(object[:tile_id])
    end

    def percentage
      total = object[:total_votes] || 0
      return 0.0 if total == 0

      (object[:count].to_f / total * 100).round(1)
    end
  end
end
