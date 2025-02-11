# frozen_string_literal: true

class WhatToDiscardProblem < ApplicationRecord
  belongs_to :user
  has_many :comments, class_name: "WhatToDiscardProblem::Comment", dependent: :destroy
  has_many :likes, class_name: "WhatToDiscardProblem::Like", dependent: :destroy

  validates :round, presence: true
  validates :turn, presence: true
  validates :wind, presence: true
  validates :dora, presence: true
  validates :point_east, presence: true
  validates :point_south, presence: true
  validates :point_west, presence: true
  validates :point_north, presence: true
  validates :hand1, presence: true
  validates :hand2, presence: true
  validates :hand3, presence: true
  validates :hand4, presence: true
  validates :hand5, presence: true
  validates :hand6, presence: true
  validates :hand7, presence: true
  validates :hand8, presence: true
  validates :hand9, presence: true
  validates :hand10, presence: true
  validates :hand11, presence: true
  validates :hand12, presence: true
  validates :hand13, presence: true
  validates :tsumo, presence: true

  validate :check_no_more_than_four_duplicated_tiles

  private

  def check_no_more_than_four_duplicated_tiles
    tiles = [ hand1, hand2, hand3, hand4, hand5, hand6, hand7, hand8, hand9, hand10, hand11, hand12, hand13, tsumo ]
    counts = tiles.tally
    duplicates = counts.select { |_, count| count > 4 }

    return unless duplicates.any?

    errors.add(:base, :too_many_duplicates)
  end
end
