class Appointment < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  belongs_to :caller, class_name: 'User', foreign_key: :caller_id

  before_validation :valid_appointment?
  after_create :send_create_emails, :write_cache
  after_destroy :send_destroy_emails, :purge_cache

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

  def self.cache_key(owner:, date:)
    owner.id.to_s + '_' + date.year.to_s + date.month.to_s + date.day.to_s + date.hour.to_s
  end

  private

  def valid_appointment?
    return if caller.has_an_appointment?(owner: owner, date: date) && id.present?
    if Rails.cache.exist?(Appointment.cache_key(owner: owner, date: date))
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

  def write_cache
    Rails.cache.write(Appointment.cache_key(owner: owner, date: date), caller_id)
  end

  def purge_cache
    Rails.cache.delete(Appointment.cache_key(owner: owner, date: date))
  end

end
