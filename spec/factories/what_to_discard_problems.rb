# frozen_string_literal: true

FactoryBot.define do
  factory :what_to_discard_problem do
    association :user, factory: :user
    round { "東一" }
    turn  { 2 }
    wind  { "東" }
    association(:dora, factory: :tile)
    point_east { 25000 }
    point_south { 25000 }
    point_west { 25000 }
    point_north { 25000 }
    association(:hand1, factory: :tile)
    association(:hand2, factory: :tile)
    association(:hand3, factory: :tile)
    association(:hand4, factory: :tile)
    association(:hand5, factory: :tile)
    association(:hand6, factory: :tile)
    association(:hand7, factory: :tile)
    association(:hand8, factory: :tile)
    association(:hand9, factory: :tile)
    association(:hand10 , factory: :tile)
    association(:hand11 , factory: :tile)
    association(:hand12 , factory: :tile)
    association(:hand13 , factory: :tile)
    association(:tsumo , factory: :tile)
  end
end
