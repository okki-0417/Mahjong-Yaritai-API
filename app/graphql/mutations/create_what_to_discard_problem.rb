module Mutations
  class CreateWhatToDiscardProblem < BaseMutation
    field :what_to_discard_problem, Types::WhatToDiscardProblemType, null: true
    field :errors, [ String ], null: false

    argument :title, String, required: true
    argument :description, String, required: false
    argument :tile_ids, [ ID ], required: true
    argument :dora_id, ID, required: false

    def resolve(title:, description: nil, tile_ids:, dora_id: nil)
      return { what_to_discard_problem: nil, errors: [ "ログインが必要です" ] } unless context[:current_user]

      problem = context[:current_user].what_to_discard_problems.build(
        title: title,
        description: description,
        dora_id: dora_id
      )

      # 牌の関連付け
      tiles = Tile.where(id: tile_ids)
      if tiles.count != tile_ids.count
        return { what_to_discard_problem: nil, errors: [ "無効な牌IDが含まれています" ] }
      end

      if tiles.count != 14
        return { what_to_discard_problem: nil, errors: [ "牌は14枚選択してください" ] }
      end

      problem.tiles = tiles

      if problem.save
        { what_to_discard_problem: problem, errors: [] }
      else
        { what_to_discard_problem: nil, errors: problem.errors.full_messages }
      end
    end
  end
end
