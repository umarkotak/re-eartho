class User < ApplicationRecord
  validates :email, uniqueness: true
  validates :username, uniqueness: true

  validates :username, :email, presence: true

  has_many :content_likes
  has_many :content_comments

  def generated_avatar_url
    prefix = username[0].to_s.upcase
    "http://47.254.247.135/eartho/default_avatar/#{prefix}.png"
  end
end
