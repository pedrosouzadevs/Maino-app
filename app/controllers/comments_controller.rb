class CommentsController < ApplicationController
  before_action :set_post, only: %i[create update destroy]
  before_action :set_comment, only: %i[update destroy]
  before_action :authenticate_user!, only: %i[ create ]


  def show
  end

  def create
    @comment = Comment.new(comment_params)
    if current_user != nil
      @comment.user_id = current_user.id
    else
      @comment.user = nil
    end
    @comment.post = @post
    if @comment.save
      redirect_to posts_path
    else
      render posts_path, status: unprocessable_entity
    end
  end

  def update
    @comment.content = params[:content]
    @comment.post_id = @post
    @comment.user_id = current_user.id
    if @comment.save
      redirect_to posts_path
    else
      render posts_path, status: unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    redirect_to post_path(@post)
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
