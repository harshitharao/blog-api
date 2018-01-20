class User < ApplicationRecord
  has_secure_password

  has_many :blogs
  has_many :favorites
  has_many :favorite_blogs, through: :favorites, source: :blog
end
