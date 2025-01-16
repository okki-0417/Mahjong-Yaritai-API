# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  validates :content_name, presence: true, length: { maximum: 100 }
  validates :reference, length: { maximum: 1000 }
  validates :description, presence: true, length: { maximum: 1000 }
end
