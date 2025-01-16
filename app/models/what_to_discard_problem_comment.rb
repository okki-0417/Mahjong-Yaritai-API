# frozen_string_literal: true

class WhatToDiscardProblemComment < ApplicationRecord
  belongs_to :user
  belongs_to :what_to_discard_problem
  has_one :reply_to_comment, class_name: :WhatToDiscardProblemComment

  validates :content, presence: true, length: { maximum: 500 }
  validate :check_reply_to_comment_parent

  private

  def check_reply_to_comment_parent
    return if reply_to_comment_id.blank?

    reply_to_comment = what_to_discard_problem.comments.find_by(id: reply_to_comment_id)
    return if reply_to_comment.present?

    errors.add(:reply_to_comment_id, :invalid)
  end
end
