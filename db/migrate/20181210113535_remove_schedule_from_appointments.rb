class RemoveScheduleFromAppointments < ActiveRecord::Migration[5.2]
  def change
    remove_column :appointments, :schedule_id, :integer
  end
end
