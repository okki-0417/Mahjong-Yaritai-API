class CreateReports < ActiveRecord::Migration[7.2]
  def change
    create_table :reports do |t|
      t.string :content_name, null: false, limit: 100
      t.string :reference, limit: 1000
      t.string :description, limit: 1000
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
