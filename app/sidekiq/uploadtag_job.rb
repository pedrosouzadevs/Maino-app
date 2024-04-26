class UploadtagJob
  include Sidekiq::Job

  def perform(tag_name, post_id)
    Tag.create!(tag_name: tag_name, post_id: post_id)
  end
end
