# frozen_string_literal: true

module Mutations
  class DeleteWhatToDiscardProblemBookmark < BaseMutation
    argument :problem_id, ID, required: true

    field :success, Boolean, null: false
    field :errors, [ String ], null: false

    def resolve(problem_id:)
      user = context[:current_user]

      unless user
        return {
          success: false,
          errors: [ "ログインが必要です" ],
        }
      end

      problem = WhatToDiscardProblem.find(problem_id)
      bookmark = user.created_bookmarks.find_by(
        bookmarkable: problem
      )

      if bookmark
        bookmark.destroy
        {
          success: true,
          errors: [],
        }
      else
        {
          success: false,
          errors: [ "お気に入りが見つかりません" ],
        }
      end
    rescue ActiveRecord::RecordNotFound
      {
        success: false,
        errors: [ "問題が見つかりません" ],
      }
    end
  end
end
