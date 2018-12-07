class ApplicationController < ActionController::Base
  private

  def require_signin
    unless current_user
      session[:intended_url] = request.url
      redirect_to root_url, alert: 'Please sign in first!'
    end
  end

  def require_professional
    unless current_user_professional?
      redirect_to root_url, alert: "Unauthorized access!"
    end
  end

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  def current_user?(user)
    current_user == user
  end

  def current_user_professional?
    current_user && current_user.professional?
  end

  helper_method :current_user
  helper_method :current_user?
  helper_method :current_user_professional?
end
