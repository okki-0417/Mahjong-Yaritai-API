# frozen_string_literal: true

class ThreadComment < ApplicationRecord
  belongs_to :thread, class_name: :ForumThread
  validates :content, presence: true, length: { maximum: 1000 }
end
