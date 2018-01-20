class Favorite < ApplicationRecord
  belongs_to :user

  def self.is_favorite_blog(blog_id, user_id)
    self.where(blog_id: blog_id, user_id: user_id).present?
  end

  def self.create_or_delete(blog_params, current_user)
    blog_id = blog_params[:id]
    if blog_params[:is_favorite].to_s === 'true'
      user_id = current_user.id
      Favorite.create!(blog_id: blog_id, user_id: user_id) unless is_favorite_blog(blog_id, user_id)
    else
      favorite_blog = current_user.favorites.where(blog_id: blog_id).first
      favorite_blog.destroy! if favorite_blog
    end
  end
end
