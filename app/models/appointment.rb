class Appointment < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  belongs_to :caller, class_name: 'User', foreign_key: :caller_id

  before_validation :valid_appointment?
  after_create :send_create_emails
  after_destroy :send_destroy_emails

  def destroy_for(current_user)
    if caller == current_user
      destroy
      true
    else
      if owner == current_user
        if Appointment.exists?(owner: owner, date: date)
          destroy
          true
        else
          errors.add(:base, :alert, message: 'You only can modify an appointment from other user (yellow hours)')
          false
        end
      else
        errors.add(:base, :alert, message: 'You only can modify your own appointments (yellow hours)')
        false
      end
    end
  end

  private

  def valid_appointment?
    return if caller.has_an_appointment?(owner: owner, date: date) && id.present?
    if Appointment.exists?(owner: owner, date: date)
      errors.add(:base, :alert, message: 'You only can take an empty appointment')
    elsif owner.works_for?(week_day: date.wday, hour: date.hour)
      # res
    else
      errors.add(:base, :alert, message: 'You only can take an appointment in green hours')
    end
  end

  def send_create_emails
    UserMailer.with(appointment: self).new_appointment_owner_email.deliver_later
    UserMailer.with(appointment: self).new_appointment_caller_email.deliver_later
  end

  def send_destroy_emails
    UserMailer.with(appointment: self).remove_appointment_caller_email.deliver_later
    UserMailer.with(appointment: self).remove_appointment_owner_email.deliver_later
  end
end
