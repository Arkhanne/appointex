class AppointmentsController < ApplicationController
  def new
    @appointment = Appointment.new
  end

  def owner_appointments
    @owner = User.find_by(id: params[:owner])
    @page = params[:page].blank? ? 1 : params[:page].to_i
  end

  def create
    owner = User.find_by(id: appointment_params[:owner_id])
    caller = User.find_by(id: appointment_params[:caller_id])
    date = appointment_params[:date].to_datetime

    if valid_appointment?(owner: owner, caller: caller, date: date)
      @appointment = Appointment.create(appointment_params)
    else
      flash.now[:alert] = 'Invalid Appointment'
      render :new
    end
  end

  private

  def appointment_params
    params.require(:appointment).permit(:owner_id, :caller_id, :date)
  end

  def valid_appointment?(owner:, caller:, date:)
    if caller.has_an_appointment?(owner: owner, date: date)
      true
    elsif Appointment.exists?(owner: owner, date: date)
      false
    elsif owner.works_for?(week_day: date.wday - 1, hour: date.hour)
      true
    else
      false
    end
  end
end
