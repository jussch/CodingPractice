class AlbumsController < ApplicationController

  before_action :require_login

  def new
    @album = Album.new
    @album.band_id = params[:band_id]
    render :new
  end

  def create
    @album = Album.new(album_params)
    if @album.save
      redirect_to album_url(@album)
    else
      flash.now[:errors] = @album.errors.full_messages
      render :new
    end
  end

  def show
    @album = Album.find(params[:id])
    render :show
  end

  def destroy
    album = Album.find(params[:id])
    album.destroy
    redirect_to band_url(album.band_id)
  end

  def update
    @album = Album.find(params[:id])
    if @album.update(album_params)
      redirect_to album_url(@album)
    else
      flash.now[:errors] = @album.errors.full_messages
      render :edit
    end
  end

  def edit
    @album = Album.find(params[:id])
    render :edit
  end

  private
  def album_params
    params.require(:album).permit(:name,:band_id,:album_type)
  end

end
