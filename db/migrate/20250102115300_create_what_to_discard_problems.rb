class CreateWhatToDiscardProblems < ActiveRecord::Migration[7.2]
  def change
    create_table :what_to_discard_problems do |t|
      t.string "round", null: false
      t.integer "turn", null: false
      t.string "wind", null: false
      t.integer "dora", null: false
      t.integer "point_east", null: false
      t.integer "point_south", null: false
      t.integer "point_west", null: false
      t.integer "point_north", null: false

      t.integer "hand1", null: false
      t.integer "hand2", null: false
      t.integer "hand3", null: false
      t.integer "hand4", null: false
      t.integer "hand5", null: false
      t.integer "hand6", null: false
      t.integer "hand7", null: false
      t.integer "hand8", null: false
      t.integer "hand9", null: false
      t.integer "hand10", null: false
      t.integer "hand11", null: false
      t.integer "hand12", null: false
      t.integer "hand13", null: false

      t.string "tsumo", null: false

      t.timestamps
    end
  end
end
