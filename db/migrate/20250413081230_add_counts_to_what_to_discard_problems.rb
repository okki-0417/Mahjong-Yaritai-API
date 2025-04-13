class AddCountsToWhatToDiscardProblems < ActiveRecord::Migration[7.2]
  def change
    add_column :what_to_discard_problems, :comments_count, :integer, default: 0, null: false
    add_column :what_to_discard_problems, :likes_count, :integer, default: 0, null: false
  end
end
