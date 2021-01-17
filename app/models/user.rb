class User < ApplicationRecord
  validates :email, uniqueness: true
  validates :username, uniqueness: true

  validates :username, :email, presence: true
end
