class ChangeUsersColumns < ActiveRecord::Migration[7.2]
  def change
    change_column :users, :password_digest, :string
  end
end
