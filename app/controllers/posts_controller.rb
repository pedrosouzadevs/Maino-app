require 'sidekiq'
class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authenticate_user!, only: %i[ new create update destroy]
  before_action :verify_user, only: [:show]
  include Sidekiq::Job

  def index
    @posts = Post.order(updated_at: :desc).page(params[:page])
    # if params[:query].present?
    #   @posts = Post.find_by(params[:query]).page(params[:page])
    # else
    #   @posts = Post.all
    # end
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

  def create_txt
    job_count = params["txt_files"].size
    completed_jobs = 0
    params[:txt_files].each do |file|
      file_content = file.read
      lines = file_content.split("\n")
      title = lines.first.strip
      completed_jobs += 1
      content = lines[1..].join("\n").strip      # Cria um novo job para processar o arquivo de texto
      UploadJob.perform_async(title, content, current_user.id)
      redirect_to posts_path if completed_jobs == job_count
    end
  end

  def create_tag

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

  def verify_user
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
