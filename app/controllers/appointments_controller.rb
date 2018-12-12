class AppointmentsController < ApplicationController
  def new
    @appointment = Appointment.new(caller_id: params[:user_id])
  end

  def owner_appointments
    @owner = User.find_by(id: params[:owner])
    @page = params[:page].blank? ? 1 : params[:page].to_i
  end

  # def create
  #   owner = User.find_by(id: appointment_params[:owner_id])
  #   caller = User.find_by(id: appointment_params[:caller_id])
  #   date = appointment_params[:date].to_datetime

  #   if valid_appointment?(owner: owner, caller: caller, date: date, action: :create)
  #     @appointment = Appointment.create(appointment_params)
  #   else
  #     flash.now[:alert] = 'You only can take an appointment in green hours'
  #     render :new
  #   end
  # end

  # def update
  #   owner = User.find_by(id: appointment_params[:owner_id])
  #   caller = User.find_by(id: appointment_params[:caller_id])
  #   date = appointment_params[:date].to_datetime

  #   if valid_appointment?(owner: owner, caller: caller, date: date, action: :update)
  #     appointment_to_delete = Appointment.find_by(id: params[:id])
  #     @appointment = Appointment.new(owner: appointment_to_delete.owner, caller: appointment_to_delete.caller, date: appointment_to_delete.date)
  #     appointment_to_delete.destroy
  #   else
  #     flash.now[:alert] = 'You only can modify your own appointments (yellow hours)'
  #     render :new
  #   end
  # end

  def create
    @appointment = Appointment.new(appointment_params)
    if @appointment.valid_appointment_for?(current_user)
      @appointment = Appointment.create(appointment_params)
    end
  end

  def update
    @appointment = Appointment.find_by(id: params[:id])
    if @appointment.destroy_for(current_user)
      @appointment = Appointment.new(owner: @appointment.owner, caller: @appointment.caller, date: @appointment.date)
    end
  end

  def index
    @owner = current_user
    @page = params[:page].blank? ? 1 : params[:page].to_i
  end
  
  private

  def appointment_params
    params.require(:appointment).permit(:owner_id, :caller_id, :date)
  end
end
