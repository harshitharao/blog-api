class Favorite < ApplicationRecord
  belongs_to :user

  def self.is_favorite_blog(blog_id, user_id)
    self.where(blog_id: blog_id, user_id: user_id).present?
  end
end
