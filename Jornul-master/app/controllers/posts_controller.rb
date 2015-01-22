class PostsController < ApplicationController
  def show
    @post = Post.find(params[:id])
    render json: @post.to_json
  end

  def index
    @posts = Post.all
    render json: @posts.to_json
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      render :json => @post.to_json
    else
      render :json => {:errors => @posts.errors.full_messages}, status: 422
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      render :json => @post.to_json
    else
      render :json => {:errors => @post.errors.full_messages}, status: 422
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    render :json => @post
  end

  private
  def post_params
    params.require(:post).permit(:title, :body)
  end
end
