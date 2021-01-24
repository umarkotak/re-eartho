class User < ApplicationRecord
  validates :email, uniqueness: true
  validates :username, uniqueness: true

  validates :username, :email, presence: true

  has_many :content_likes
  has_many :content_comments
end
