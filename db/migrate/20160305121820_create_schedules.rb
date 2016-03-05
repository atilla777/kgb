class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.references :job, index: true, foreign_key: true
      t.integer :week_day
      t.integer :month_day

      t.timestamps null: false
    end
    add_index :schedules, :week_day
    add_index :schedules, :month_day
  end
end
