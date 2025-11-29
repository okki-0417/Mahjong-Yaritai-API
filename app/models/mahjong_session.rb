# frozen_string_literal: true

class MahjongSession < ApplicationRecord
  belongs_to :creator_user, class_name: :User
  belongs_to :mahjong_scoring_setting

  has_many :mahjong_games, dependent: :destroy
  has_many :mahjong_participants, dependent: :destroy
  has_many :participants, through: :mahjong_participants, source: :user

  delegate :rate, :chip_amount, :uma_rule_label, :oka_rule_label, to: :mahjong_scoring_setting
end
