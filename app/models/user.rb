class User < ApplicationRecord
  validates :email, uniqueness: true
  validates :username, uniqueness: true

  validates :username, :email, presence: true

  has_many :contents
  has_many :content_likes
  has_many :content_comments

  def generated_avatar_url
    colors = ['blue', 'green', 'orange', 'purple', 'red']
    prefix = username[0].to_s.upcase

    if ['A', 'B', 'C', 'D', 'E'].include?(prefix)
      idx = 0
    elsif ['F', 'G', 'H', 'I', 'J'].include?(prefix)
      idx = 1
    elsif ['K', 'L', 'M', 'N', 'O'].include?(prefix)
      idx = 2
    elsif ['P', 'Q', 'R', 'S', 'T'].include?(prefix)
      idx = 3
    else
      idx = 4
    end

    "http://47.254.247.135/eartho/default_avatar/#{colors[idx]}/#{prefix}.png"
  end

  def liked_content_ids
    @liked_content_ids ||= ContentLike.where(user_id: id).pluck(:id)
  end
end
