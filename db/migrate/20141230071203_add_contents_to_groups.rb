class AddContentsToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :contents, :text
  end
end
