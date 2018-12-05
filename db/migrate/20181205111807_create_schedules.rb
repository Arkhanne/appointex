class CreateSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :schedules do |t|
      t.integer :week_day
      t.integer :hour
      t.references :owner, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
