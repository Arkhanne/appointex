class AppointmentsController < ApplicationController
  def new
    @appointment = Appointment.new
  end

  def owner_appointments
    @owner = User.find_by(id: params[:owner])
    @page = params[:page].blank? ? 1 : params[:page].to_i
  end

  def create
    @appointment = Appointment.create(appointment_params)
  end

  private

  def appointment_params
    params.require(:appointment).permit(:owner_id, :caller_id, :date)
  end
end

