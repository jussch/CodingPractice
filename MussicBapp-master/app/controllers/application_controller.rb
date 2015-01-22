class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :logged_in?

  def current_user
    return nil if session[:token].nil?
    @cu ||= User.find_by_session_token(session[:token])
  end

  def logged_in?
    !!current_user
  end

  def log_in_user!(user)
    session[:token] = user.reset_session_token!
  end

  def logout_user!
    current_user.reset_session_token!
  end

  def require_login
    unless logged_in?
      redirect_to new_session_url
    end
  end
end
