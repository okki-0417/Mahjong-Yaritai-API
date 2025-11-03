# frozen_string_literal: true

class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :bookmarkable, polymorphic: true, counter_cache: true

  validates :user_id, uniqueness: { scope: %i[bookmarkable_type bookmarkable_id] }
  validate :prevent_self_bookmark

  def bookmarked_by?(user)
    user_id == user.id
  end

  private

  def prevent_self_bookmark
    return unless bookmarkable_type == "WhatToDiscardProblem"

    return unless bookmarkable&.user_id == user_id

    errors.add(:base, "自分の問題はブックマークできません")
  end
end
