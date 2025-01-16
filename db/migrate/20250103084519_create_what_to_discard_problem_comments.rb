class CreateWhatToDiscardProblemComments < ActiveRecord::Migration[7.2]
  def change
    create_table :what_to_discard_problem_comments do |t|
      t.references :user, null: false
      t.references :reply_to_comment, foreign_key: { to_table: :what_to_discard_problem_comments }, null: true
      t.string :content, null: false, limit: 500
      t.timestamps
    end
  end
end
