class AddContentsTogroups < ActiveRecord::Migration
  def change
    add_column :groups, :contents, :text
  end
end
