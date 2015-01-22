class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :signed_in?


  def current_user
    return nil unless session[:token]
    @cu ||= User.find_by_session_token(session[:token])
  end

  def log_in_user!(user)
    session[:token] = user.reset_session_token!
  end

  def signed_in?
    !!current_user
  end

  def log_out!
    current_user.try(:reset_session_token!)
    session[:token] = nil
  end

  def vote(val)
    model_class = controller_name.classify.constantize
    model_class.find(params[:id]).votes.create(value: val, voter_id: current_user.id)
    redirect_to :back
  end

  def upvote
    vote(1)
  end

  def downvote
    vote(-1)
    #self.votes.create(value: -1, voter_id: current_user.id)
  end

end
