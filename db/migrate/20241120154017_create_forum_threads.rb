class CreateForumThreads < ActiveRecord::Migration[7.2]
  def change
    create_table :forum_threads do |t|
      t.references :user, null: false, foreign_key: true
      t.string :topic, null: false, limit: 100

      t.timestamps
    end
  end
end
