class UserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    @url  = "http://#{default_url_options[:host]}/session/signin"
    mail(to: @user.email, subject: 'Welcome to Appointex')
  end

  def new_appointment_owner_email
    @appointment = params[:appointment]
    @url = "http://#{default_url_options[:host]}/session/signin"
    mail(to: @appointment.owner.email, subject: 'You have a new appointment')
  end

  def new_appointment_caller_email
    @appointment = params[:appointment]
    @url = "http://#{default_url_options[:host]}/session/signin"
    mail(to: @appointment.caller.email, subject: 'You have a new appointment')
  end

  def remove_appointment_owner_email
    @appointment = params[:appointment]
    @url = "http://#{default_url_options[:host]}/session/signin"
    mail(to: @appointment.owner.email, subject: 'An appointment has been removed')
  end

  def remove_appointment_caller_email
    @appointment = params[:appointment]
    @url = "http://#{default_url_options[:host]}/session/signin"
    mail(to: @appointment.caller.email, subject: 'An appointment has been removed')
  end
end
