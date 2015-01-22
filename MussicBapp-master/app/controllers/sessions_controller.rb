class SessionsController < ApplicationController

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.find_by_credentials(user_params[:email],user_params[:password])
    if @user
      log_in_user!(@user)
      redirect_to bands_url
    else
      flash.now[:errors] = ["That email/password doesn't exist"]
      @user = User.new(user_params)
      render :new
    end
  end

  def destroy
    logout_user!
    redirect_to new_session_url
  end

  private
  def user_params
    params.require(:user).permit(:email, :password)
  end
end
