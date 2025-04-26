class ChangeDetailsOfWhatToDiscardProblem < ActiveRecord::Migration[7.2]
  def change
    remove_column :what_to_discard_problems, :dora
    add_reference :what_to_discard_problems, :dora, foreign_key: { to_table: :tiles }, null: false

    remove_column :what_to_discard_problems, :tsumo
    add_reference :what_to_discard_problems, :tsumo, foreign_key: { to_table: :tiles }, null: false

    remove_column :what_to_discard_problems, :hand1
    add_reference :what_to_discard_problems, :hand1, foreign_key: { to_table: :tiles }, null: false

    remove_column :what_to_discard_problems, :hand2
    add_reference :what_to_discard_problems, :hand2, foreign_key: { to_table: :tiles }, null: false

    remove_column :what_to_discard_problems, :hand3
    add_reference :what_to_discard_problems, :hand3, foreign_key: { to_table: :tiles }, null: false

    remove_column :what_to_discard_problems, :hand4
    add_reference :what_to_discard_problems, :hand4, foreign_key: { to_table: :tiles }, null: false

    remove_column :what_to_discard_problems, :hand5
    add_reference :what_to_discard_problems, :hand5, foreign_key: { to_table: :tiles }, null: false

    remove_column :what_to_discard_problems, :hand6
    add_reference :what_to_discard_problems, :hand6, foreign_key: { to_table: :tiles }, null: false

    remove_column :what_to_discard_problems, :hand7
    add_reference :what_to_discard_problems, :hand7, foreign_key: { to_table: :tiles }, null: false

    remove_column :what_to_discard_problems, :hand8
    add_reference :what_to_discard_problems, :hand8, foreign_key: { to_table: :tiles }, null: false

    remove_column :what_to_discard_problems, :hand9
    add_reference :what_to_discard_problems, :hand9, foreign_key: { to_table: :tiles }, null: false

    remove_column :what_to_discard_problems, :hand10
    add_reference :what_to_discard_problems, :hand10, foreign_key: { to_table: :tiles }, null: false

    remove_column :what_to_discard_problems, :hand11
    add_reference :what_to_discard_problems, :hand11, foreign_key: { to_table: :tiles }, null: false

    remove_column :what_to_discard_problems, :hand12
    add_reference :what_to_discard_problems, :hand12, foreign_key: { to_table: :tiles }, null: false

    remove_column :what_to_discard_problems, :hand13
    add_reference :what_to_discard_problems, :hand13, foreign_key: { to_table: :tiles }, null: false
  end
end
