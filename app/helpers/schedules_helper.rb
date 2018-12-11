module SchedulesHelper
  def schedules_week_days(page)
    days = []

    0.upto(6).each do |week_day|
      days << (Date.today + (page - 1).weeks).beginning_of_week + week_day.days
    end

    days
  end

  def schedules_schedule_class(owner:, date:)
    if Appointment.exists?(owner: owner, date: date)
      'appointment'
    elsif owner.works_for?(week_day: date.wday - 1, hour: date.hour)
      'active'
    else
      'not-active'
    end
  end
end
