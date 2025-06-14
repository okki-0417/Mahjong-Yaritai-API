# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true, counter_cache: true
  belongs_to :parent_comment, class_name: :Comment, foreign_key: :parent_comment_id, optional: true
  has_many :replies, class_name: :Comment, foreign_key: :parent_comment_id

  validates :content, presence: true, length: { maximum: 500 }
  validate :check_parent_comment_association

  scope :parents, -> { where(parent_comment_id: nil) }

  private

  def parent_comment?
    parent_comment_id.blank?
  end

  def check_parent_comment_association
    return if parent_comment?

    parent_comment = Comment.find_by(id: parent_comment_id)
    return if parent_comment

    errors.add(:parent_comment_id, :missing_parent_comment)
  end
end
