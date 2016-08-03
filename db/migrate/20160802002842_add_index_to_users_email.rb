class AddIndexToUsersEmail < ActiveRecord::Migration[5.0]
  def change
    # add index to user emails to ensure uniqueness at db level
    add_index :users, :email, unique: true
    # add_index - rails method, users table, email column
  end
end
