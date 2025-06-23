# frozen_string_literal: true

module Resolvers
  class WhatToDiscardProblemsResolver < Resolvers::BaseResolver
    type Types::WhatToDiscardProblemsConnectionType, null: false

    argument :page, Int, required: true
    argument :per, Int, required: false, default_value: 20

    def resolve(page:, per: 20)
      problems = WhatToDiscardProblem.all
        .page(page)
        .order(created_at: :desc)
        .per(per)
        .preload(
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
                                      :user,
                                    )

      {
        data: problems,
        meta: {
          pagination: {
            total_pages: problems.total_pages,
            current_page: problems.current_page,
            prev_page: problems.prev_page,
            next_page: problems.next_page,
            first_page: 1,
            last_page: problems.total_pages,
          },
        },
      }
    end
  end
end
