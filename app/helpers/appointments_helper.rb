module AppointmentsHelper
  def appointments_week_days(page)
    days = []

    0.upto(6).each do |week_day|
      days << (Date.today + (page - 1).weeks).beginning_of_week + week_day.days
    end

    days
  end

  def appointments_schedule_class(owner:, caller:, date:)
    if caller.has_an_appointment?(owner: owner, date: date)
      'self-appointment'
    elsif Appointment.exists?(owner: owner, date: date)
      'appointment'
    elsif owner.works_for?(week_day: date.wday - 1, hour: date.hour)
      'active'
    else
      'not-active'
    end
  end

  def appointment_name_to_show(appointment:)
    appointment.caller.name if appointment.id? && appointment.owner.id == current_user.id
  end
end
