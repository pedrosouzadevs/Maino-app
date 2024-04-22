class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authenticate_user!, only: %i[ new create update destroy]
  before_action :verificar_usuario, only: [:show]

  def index
    @posts = Post.order(updated_at: :desc).page(params[:page])

  end

  def show
    if @deletar_notificacao
      Notification.where(post_id: @post.id, user_id: current_user.id).destroy_all
    end
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
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "Post was successfully deleted."
  end

  private

  def set_post
    @post = Post.find(params[:id])
    @comments = @post.comments
  end

  def verificar_usuario
      if current_user && current_user.id == Post.find(params[:id]).user_id
      @deletar_notificacao = true
    else
      @deletar_notificacao = false
    end
  end

  def post_params
    params.require(:post).permit(:content, :title)
  end
end
