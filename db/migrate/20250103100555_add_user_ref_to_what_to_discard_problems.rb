class AddUserRefToWhatToDiscardProblems < ActiveRecord::Migration[6.0]
  def change
    unless column_exists?(:what_to_discard_problems, :user_id)
      add_reference :what_to_discard_problems, :user, null: false, foreign_key: true
    end
  end
end
