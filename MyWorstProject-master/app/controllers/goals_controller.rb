class GoalsController < ApplicationController

  before_action :ensure_logged_in

  def index
    @goals = Goal.where(access: "Public")
    render :index
  end

  def new
    @goal = Goal.new
    render :new
  end

  def create
    @goal = Goal.new(goal_params)
    @goal.completion = "Incomplete"
    @goal.user_id = current_user.id
    if @goal.save
      redirect_to goal_url(@goal)
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :new
    end
  end

  def show
    @goal = Goal.find(params[:id])
    render :show
  end

  def destroy
    goal = Goal.find(params[:id])
    goal.destroy
    redirect_to goals_url
  end

  def edit
    @goal = Goal.find(params[:id])
    render :edit
  end

  def update
    @goal = Goal.find(params[:id])
    if @goal.update(goal_params)
      redirect_to goal_url(@goal)
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :edit
    end
  end

  def complete
    @goal = Goal.find(params[:goal_id])
    @goal.complete_goal
    unless @goal.save
      flash[:errors] = @goal.errors.full_messages
    end
    redirect_to goal_url(@goal)
  end

  private
  def goal_params
    params.require(:goal).permit(:title, :content, :access)
  end
end
