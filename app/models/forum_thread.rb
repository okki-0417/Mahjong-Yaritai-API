# frozen_string_literal: true

class ForumThread < ApplicationRecord
  validates :topic, presence: true, length: { maximum: 100 }

  belongs_to :created_user, class_name: :User, foreign_key: :user_id
  has_many :comments, class_name: :ThreadComment, dependent: :destroy
end
