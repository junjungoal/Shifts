class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.integer :status
      t.integer :user_id
      t.date  :date
      t.integer :group_id
      t.text  :shift_time
      t.timestamps
    end
  end
end
