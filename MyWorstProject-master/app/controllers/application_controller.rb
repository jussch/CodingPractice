class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :signed_in?

  def signed_in?
    !!current_user
  end

  def log_in_user!(user)
    session[:token] = user.reset_session_token!
  end

  def log_out_user!
    current_user.reset_session_token!
    session[:token] = nil
    redirect_to new_session_url
  end

  def current_user
    return nil if session[:token].nil?
    @cu ||= User.find_by(session_token: session[:token])
  end

  def ensure_logged_in
    unless signed_in?
      redirect_to new_session_url
    end
  end
end
