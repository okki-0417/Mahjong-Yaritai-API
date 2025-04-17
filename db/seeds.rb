# frozen_string_literal: true

require "factory_bot_rails"

FactoryBot.create(:user, name: "ohki", email:  "ouki_murai@ostance.com")

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
