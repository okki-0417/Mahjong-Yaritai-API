class WhatToDiscardProblem::VoteSerializer < ActiveModel::Serializer
  attributes %i[
    id
  ]

  belongs_to :user, serializer: UserSerializer
  belongs_to :what_to_discard_problem, serializer: WhatToDiscardProblemSerializer
  belongs_to :tile, serializer: TileSerializer
end
