module Mutations
  class UpdateWhatToDiscardProblem < BaseMutation
    field :what_to_discard_problem, Types::WhatToDiscardProblemType, null: true
    field :errors, [ String ], null: false

    argument :id, ID, required: true
    argument :title, String, required: false
    argument :description, String, required: false
    argument :tile_ids, [ ID ], required: false
    argument :dora_id, ID, required: false

    def resolve(id:, **attributes)
      return { what_to_discard_problem: nil, errors: [ "ログインが必要です" ] } unless context[:current_user]

      problem = context[:current_user].what_to_discard_problems.find_by(id: id)

      unless problem
        return { what_to_discard_problem: nil, errors: [ "問題が見つかりません" ] }
      end

      # tile_idsが指定されている場合は牌を更新
      if attributes[:tile_ids]
        tiles = Tile.where(id: attributes[:tile_ids])
        if tiles.count != attributes[:tile_ids].count
          return { what_to_discard_problem: nil, errors: [ "無効な牌IDが含まれています" ] }
        end

        if tiles.count != 14
          return { what_to_discard_problem: nil, errors: [ "牌は14枚選択してください" ] }
        end

        problem.tiles = tiles
        attributes.delete(:tile_ids)
      end

      if problem.update(attributes)
        { what_to_discard_problem: problem, errors: [] }
      else
        { what_to_discard_problem: nil, errors: problem.errors.full_messages }
      end
    end
  end
end
