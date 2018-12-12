class Appointment < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  belongs_to :caller, class_name: 'User', foreign_key: :caller_id

  before_validation :valid_appointment?

  def destroy_for(current_user)
    if caller == current_user
      destroy
      true
    else
      errors.add(:base, :alert, message: 'You only can modify your own appointments (yellow hours)')
      false
    end
  end

  private

  def valid_appointment?
    return if caller.has_an_appointment?(owner: owner, date: date) && id.present?
    if Appointment.exists?(owner: owner, date: date)
      errors.add(:base, :alert, message: 'You only can take an empty appointment')
    elsif owner.works_for?(week_day: date.wday - 1, hour: date.hour) && !id.present?
      # res
    else
      errors.add(:base, :alert, message: 'You only can take an appointment in green hours')
    end
  end
end
