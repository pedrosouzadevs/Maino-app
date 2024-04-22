class CommentsController < ApplicationController
  before_action :set_post, only: %i[new create]
  before_action :authenticate_user!, except: %i[ new create ]

  def new
  end

  def create
    @comment = Comment.new(comment_params)
    if current_user != nil
      @comment.user_id = current_user.id
    else
      @comment.user_id = nil
    end
    @comment.post = @post
    if @comment.save
      comment_id = @comment.id
      @notifications = Notification.create(user_id: @post.user_id, post_id: @post.id, comment_id: comment_id)
      redirect_to post_path(@post)
    else
      render post_comments_path(@post), status: unprocessable_entity
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

end
