class PostsController < ApplicationController
  before_action :set_post, only: %i[show update destroy]
  before_action :authenticate_user!, only: %i[ new create update destroy]
  before_action :time_period, only: %i[ show]

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
    @post.title = params[:title]
    @post.user_id = current_user.id
    if @post.save
      redirect_to :back
    else
      render :edit, status: unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to index
  end

  private

  def time_period
    @posts = Post.all
    @posts_array = []
    @posts.each do |post|
      @time_period = ((Time.now - post.created_at) / 60).to_i
      if @time_period < 60
        time_ago = "#{@time_period} minutes ago"
      elsif @time_period < 1440 && @time_period >= 60
        time_ago = "#{@time_period} hours ago"
      elsif @time_period < 43200 && @time_period >= 1440
        time_ago = "#{@time_period /24} days ago"
      elsif @time_period < 518400 && @time_period >= 43200
        time_ago = "#{Time.now - post.created_at/30} months ago"
      end
      @posts_array << {  title: post.title,
                        content: post.content,
                        time_period: time_ago,
                        post_id: post.id
      }
    end
  end

  def set_post
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments
  end

  def post_params
    params.require(:post).permit(:content, :title)
  end
end
