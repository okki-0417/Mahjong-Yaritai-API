# frozen_string_literal: true

module Mutations
  class CreateWhatToDiscardProblemBookmark < BaseMutation
    argument :problem_id, ID, required: true

    field :bookmark, Types::BookmarkType, null: true
    field :success, Boolean, null: false
    field :errors, [ String ], null: false

    def resolve(problem_id:)
      user = context[:current_user]

      unless user
        return {
          bookmark: nil,
          success: false,
          errors: [ "ログインが必要です" ],
        }
      end

      problem = WhatToDiscardProblem.find(problem_id)

      bookmark = user.created_bookmarks.build(
        bookmarkable: problem
      )

      if bookmark.save
        {
          bookmark: bookmark,
          success: true,
          errors: [],
        }
      else
        {
          bookmark: nil,
          success: false,
          errors: bookmark.errors.full_messages,
        }
      end
    rescue ActiveRecord::RecordNotFound
      {
        bookmark: nil,
        success: false,
        errors: [ "問題が見つかりません" ],
      }
    end
  end
end
