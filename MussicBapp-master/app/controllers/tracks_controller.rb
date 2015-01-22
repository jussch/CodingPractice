class TracksController < ApplicationController

  before_action :require_login

  def new
    @track = Track.new
    @track.album_id = params[:album_id]
    render :new
  end

  def create
    @track = Track.new(track_params)
    if @track.save
      redirect_to album_url(@track.album_id)
    else
      flash.now[:errors] = @track.errors.full_messages
      render :new
    end
  end

  def show
    @track = Track.find(params[:id])
    render :show
  end

  def destroy
    track = Track.find(params[:id])
    track.destroy
    redirect_to album_url(track.album_id)
  end

  def update
    @track = Track.find(params[:id])
    if @track.update(track_params)
      redirect_to track_url(@track)
    else
      flash.now[:errors] = @track.errors.full_messages
      render :edit
    end
  end

  def edit
    @track = Track.find(params[:id])
    render :edit
  end

  private
  def track_params
    params.require(:track).permit(:name,:album_id,:track_type,:lyrics)
  end

end
