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

    if valid_appointment?(owner: owner, caller: caller, date: date, action: :create)
      @appointment = Appointment.create(appointment_params)
    else
      flash.now[:alert] = 'You only can take an appointment in green hours'
      render :new
    end
  end

  def update
    owner = User.find_by(id: appointment_params[:owner_id])
    caller = User.find_by(id: appointment_params[:caller_id])
    date = appointment_params[:date].to_datetime

    if valid_appointment?(owner: owner, caller: caller, date: date, action: :update)
      appointment_to_delete = Appointment.find_by(id: params[:id])
      @appointment = Appointment.new(owner: appointment_to_delete.owner, caller: appointment_to_delete.caller, date: appointment_to_delete.date)
      appointment_to_delete.destroy
    else
      flash.now[:alert] = 'You only can modify your own appointments (yellow hours)'
      render :new
    end
  end

  private

  def appointment_params
    params.require(:appointment).permit(:owner_id, :caller_id, :date)
  end

  def valid_appointment?(owner:, caller:, date:, action:)
    if caller.has_an_appointment?(owner: owner, date: date) && action == :update
      puts 'HAS AN APPOINTMENT'
      true
    elsif Appointment.exists?(owner: owner, date: date)
      false
    elsif owner.works_for?(week_day: date.wday - 1, hour: date.hour) && action == :create
      puts 'WORKS FOR'
      true
    else
      false
    end
  end
end
