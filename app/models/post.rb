class Post < ApplicationRecord
  validates :content, presence: true
  validates :title, presence: true
  validates :user_id, presence: true
  paginates_per 3
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :tags, dependent: :destroy
  belongs_to :user
end
