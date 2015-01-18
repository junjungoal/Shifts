class AddNatureToUsers < ActiveRecord::Migration
  def change
    add_column :users, :nature, :integer
    add_column :users, :group_id, :integer
    add_column :users, :username, :string
  end
end
