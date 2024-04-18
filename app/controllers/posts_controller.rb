class PostsController < ApplicationController
  before_action :set_post, only: %i[update destroy]
  before_action :authenticate_user!, only: %i[ new create update destroy]

  def index
    @posts = Post.order(updated_at: :desc).page(params[:page])
  end

  def show

  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to posts_path
    else
      render posts_path, status: unprocessable_entity
    end
  end

  def update
    @post.content = params[:content]
    @post.user_id = current_user.id
    if @post.save
      redirect_to posts_path
    else
      render posts_path, status: unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to index
  end

  private

  def set_post
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments
  end

  def post_params
    params.require(:post).permit(:content, :title)
  end
end