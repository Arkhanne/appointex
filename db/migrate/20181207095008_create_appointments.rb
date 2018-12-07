class CreateAppointments < ActiveRecord::Migration[5.2]
  def change
    create_table :appointments do |t|
      t.references :schedule, foreign_key: {to_table: :schedules}
      t.references :owner, foreign_key: {to_table: :users}
      t.references :caller, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
