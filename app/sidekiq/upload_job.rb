class UploadJob
  include Sidekiq::Job

  def perform(title, content, current_user)
    Post.create!(user_id: current_user, title: title, content: content)
  end
end
