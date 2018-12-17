class AppointmentsController < ApplicationController
  def new
    @appointment = Appointment.new(caller_id: params[:user_id])
  end

  def owner_appointments
    @owner = User.find_by(id: params[:owner])
    @page = params[:page].blank? ? 1 : params[:page].to_i
  end

  def create
    @appointment = Appointment.create(appointment_params)
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

  def list
    @appointments = current_user.caller_appointments.order(date: :asc)
  end

  def destroy
    appointment = Appointment.find_by(id: params[:id])
    appointment.destroy
    redirect_to user_appointments_list_path(current_user), alert: "Appointment successfuly removed!"
  end

  private

  def appointment_params
    params.require(:appointment).permit(:owner_id, :caller_id, :date)
  end
end
