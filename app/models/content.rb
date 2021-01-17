class Content < ApplicationRecord
  belongs_to :user
  has_many :content_comments

  validates :title, :description, :image_url, presence: true
end
