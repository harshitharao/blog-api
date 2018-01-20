class Blog < ApplicationRecord
  validates_presence_of :title

  has_many :favorited_by_users, through: :favorites, source: :user
end
