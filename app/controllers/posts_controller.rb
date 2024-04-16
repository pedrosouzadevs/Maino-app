class PostsController < ApplicationController
  before_action :set_post, only: %i[update destroy]
  before_action :set_event, only: %i[create update destroy]
  before_action :authenticate_user!, only: %i[create update destroy]

  def index
    @posts = Post.order(updated_at: :desc).page(params[:page])
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to event_path(@event)
    else
      render "events/show", status: unprocessable_entity
    end
  end

  def update
    @post.content = params[:content]
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_path(@post)
    else
      render "index", status: unprocessable_entity
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
    params.require(:post).permit(:content)
  end
end
