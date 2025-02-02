class CreateTempUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :temp_users do |t|
      t.string :email, null: false
      t.string :token, null: false
      t.datetime :expired_at, null: false, precision: false
      t.timestamps
    end
  end
end
