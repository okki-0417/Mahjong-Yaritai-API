# frozen_string_literal: true

module Resolvers
  class WhatToDiscardProblemResolver < BaseResolver
    type Types::WhatToDiscardProblemType, null: true

    argument :id, ID, required: true

    def resolve(id:)
      WhatToDiscardProblem.find_by(id: id)
        .preload(
          :user,
          :dora,
          :hand1,
          :hand2,
          :hand3,
          :hand4,
          :hand5,
          :hand6,
          :hand7,
          :hand8,
          :hand9,
          :hand10,
          :hand11,
          :hand12,
          :hand13,
          :tsumo,
          :likes,
          :bookmarks,
          :votes,
          user: :avatar_attachment,
        )
    end
  end
end
