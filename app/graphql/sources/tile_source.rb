# frozen_string_literal: true

module Sources
  class TileSource < GraphQL::Dataloader::Source
    def fetch(tile_ids)
      # ランダムアクセスパフォーマンスを向上させるためハッシュでインデックス化
      tiles = Tile.where(id: tile_ids).index_by(&:id)

      # IDの順序を保持して結果を返す
      tile_ids.map { |id| tiles[id] }
    end
  end
end
