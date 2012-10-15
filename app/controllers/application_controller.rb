class ApplicationController < ActionController::Base
  protect_from_forgery
  force_ssl
  helper_method :current_user

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_user=(user)
    session.clear
    session[:user_id] = user.id
  end

  def authenticate_user!
    redirect_to login_path unless current_user
  end

end
