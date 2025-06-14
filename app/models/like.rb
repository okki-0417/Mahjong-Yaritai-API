# frozen_string_literal: true

class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likable, polymorphic: true, counter_cache: true

  validates :user_id, uniqueness: { scope: [:likable_type, :likable_id] }
end
