class AppointmentsController < ApplicationController
  @@owner = nil

  def new
    @appointment = Appointment.new
    if @@owner
      @owner_appointments = Schedule.where(:owner => @@owner).all
    end
  end

  def get_data
    @@owner = params[:owner]
    if @@owner
      @owner_appointments = Schedule.where(:owner => @@owner).all
    end
    new
    render :new
  end
end
