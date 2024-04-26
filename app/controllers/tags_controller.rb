class TagsController < ApplicationController
  before_action :set_post, only: %i[new]
  before_action :authenticate_user!, except: %i[ new create ]

  def new
    @tag = Tag.new
  end


  def create
    completed_jobs = 0
    tag_names = params[:tag][:tag_name].split(' ')
    job_count = tag_names.size
    tag_names.each do |tag_name|
      post_id = params[:post_id]
      completed_jobs += 1
      UploadtagJob.perform_async(tag_name, post_id)
      redirect_to post_path(params[:post_id]) if completed_jobs == job_count
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def tag_params
    params.require(:tag).permit(:tag_name)
  end
end
