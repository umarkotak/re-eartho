class Content < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :content_comments
  has_many :content_likes

  validates :title, :description, :image_url, presence: true

  def liked_by_user(user_id)
    return false if user_id.blank?
    return true if ContentLike.find_by(content_id: id, user_id: user_id)
    false
  end
end
