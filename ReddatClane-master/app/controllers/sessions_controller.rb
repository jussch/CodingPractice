class SessionsController < ApplicationController
  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.find_by_credentials(
      params[:user][:name],
      params[:user][:password],
    )

    if @user
      log_in_user!(@user)
      redirect_to user_url(@user)
    else
      flash.now[:notice] = ["Invalid Username/Password"]
      render :new
    end
  end

  def destroy
    log_out!
    redirect_to new_sessions_url
  end


  private
  def user_params
    params.require(:user).permit(:name,:password)
  end


end
