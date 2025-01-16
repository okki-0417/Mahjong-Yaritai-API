class CreateThreadComments < ActiveRecord::Migration[7.2]
  def change
    create_table :thread_comments do |t|
      t.references :forum_thread, null: false, foreign_key: true
      t.references :thread_comment, foreign_key: true, default: 0
      t.string :content, limit: 1000

      t.timestamps
    end
    add_index :thread_comments, :created_at
  end
end
