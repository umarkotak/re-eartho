class User < ApplicationRecord
  validates :email, uniqueness: true
  validates :username, uniqueness: true
end
