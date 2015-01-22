class UsersController < ApplicationController

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in_user!(@user)
      redirect_to user_url(@user)
    else
      flash.now[:notice] = @user.errors.full_messages
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    render :show
  end

  def vote_count
    result = 0
    self.votes.each do |vote|
      result += vote.value
    end
    result
  end
  
  private
  def user_params
    params.require(:user).permit(:name,:password)
  end
end
