class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.text :shifttime
      t.integer :group_id
      t.integer :max_people
      t.timestamps
    end
  end
end
