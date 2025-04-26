# frozen_string_literal: true

require "factory_bot_rails"

user = FactoryBot.create(:user, name: "ohki", email:  "ouki_murai@ostance.com")

[
  {suit: "manzu", ordinal_number_in_suit: 1, name: "一萬"},
  {suit: "manzu", ordinal_number_in_suit: 2, name: "二萬"},
  {suit: "manzu", ordinal_number_in_suit: 3, name: "三萬"},
  {suit: "manzu", ordinal_number_in_suit: 4, name: "四萬"},
  {suit: "manzu", ordinal_number_in_suit: 5, name: "五萬"},
  {suit: "manzu", ordinal_number_in_suit: 6, name: "六萬"},
  {suit: "manzu", ordinal_number_in_suit: 7, name: "七萬"},
  {suit: "manzu", ordinal_number_in_suit: 8, name: "八萬"},
  {suit: "manzu", ordinal_number_in_suit: 9, name: "九萬"},
  {suit: "pinzu", ordinal_number_in_suit: 1, name: "一筒"},
  {suit: "pinzu", ordinal_number_in_suit: 2, name: "二筒"},
  {suit: "pinzu", ordinal_number_in_suit: 3, name: "三筒"},
  {suit: "pinzu", ordinal_number_in_suit: 4, name: "四筒"},
  {suit: "pinzu", ordinal_number_in_suit: 5, name: "五筒"},
  {suit: "pinzu", ordinal_number_in_suit: 6, name: "六筒"},
  {suit: "pinzu", ordinal_number_in_suit: 7, name: "七筒"},
  {suit: "pinzu", ordinal_number_in_suit: 8, name: "八筒"},
  {suit: "pinzu", ordinal_number_in_suit: 9, name: "九筒"},
  {suit: "souzu", ordinal_number_in_suit: 1, name: "一索"},
  {suit: "souzu", ordinal_number_in_suit: 2, name: "二索"},
  {suit: "souzu", ordinal_number_in_suit: 3, name: "三索"},
  {suit: "souzu", ordinal_number_in_suit: 4, name: "四索"},
  {suit: "souzu", ordinal_number_in_suit: 5, name: "五索"},
  {suit: "souzu", ordinal_number_in_suit: 6, name: "六索"},
  {suit: "souzu", ordinal_number_in_suit: 7, name: "七索"},
  {suit: "souzu", ordinal_number_in_suit: 8, name: "八索"},
  {suit: "souzu", ordinal_number_in_suit: 9, name: "九索"},
  {suit: "ji", ordinal_number_in_suit: 1, name: "東"},
  {suit: "ji", ordinal_number_in_suit: 2, name: "南"},
  {suit: "ji", ordinal_number_in_suit: 3, name: "西"},
  {suit: "ji", ordinal_number_in_suit: 4, name: "北"},
  {suit: "ji", ordinal_number_in_suit: 5, name: "白"},
  {suit: "ji", ordinal_number_in_suit: 6, name: "發"},
  {suit: "ji", ordinal_number_in_suit: 7, name: "中"},
].each do |obj|
  FactoryBot.create(:tile, obj)
end


problem = FactoryBot.create(:what_to_discard_problem, user:, dora_id: 1, hand1_id: 1, hand2_id: 2, hand3_id: 3, hand4_id: 4, hand5_id: 5, hand6_id: 6, hand7_id: 7, hand8_id: 8, hand9_id: 9, hand10_id: 10, hand11_id: 11, hand12_id: 12, hand13_id: 13, tsumo_id: 14)
FactoryBot.create(:what_to_discard_problem_like, what_to_discard_problem_id: problem.id, user:)
FactoryBot.create(:what_to_discard_problem_comment, what_to_discard_problem_id: problem.id, user:)
FactoryBot.create(:what_to_discard_problem_vote, what_to_discard_problem_id: problem.id, user:, tile_id: 1)
