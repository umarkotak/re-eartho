class Content < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :content_comments

  validates :title, :description, :image_url, presence: true
end
