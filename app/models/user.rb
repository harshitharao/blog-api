class User < ApplicationRecord
  has_secure_password

  has_many :blogs
  has_many :favorites
end
