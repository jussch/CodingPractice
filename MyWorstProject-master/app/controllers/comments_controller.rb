class CommentsController < ApplicationController
  before_action :ensure_logged_in

  def new
    @comment = Comment.new
    render :new
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      comment_redirect
    else
      flash[:errors] = @comment.errors.full_messages
      comment_redirect
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    comment_redirect
  end

  def comment_params
    params.require(:comment).permit(:body, :commentable_id, :commentable_type)
  end

  def comment_redirect
    redirect_to self.send("#{@comment.commentable_type.downcase}_url".to_sym,
      @comment.commentable_id)
  end

end
