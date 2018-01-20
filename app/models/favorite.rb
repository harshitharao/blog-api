class Favorite < ApplicationRecord
  belongs_to :user

  def self.is_favorite_blog(blog_id, user_id)
    self.where(blog_id: blog_id, user_id: user_id).present?
  end

  def self.create_or_delete(blog_params, current_user)
    if blog_params[:is_favorite] === 'true'
      Favorite.create!(blog_id: blog_params[:id], user_id: current_user.id) if Favorite.where(blog_id: blog_params[:id], user_id: current_user.id).empty?
    else
      favorite_blog = current_user.favorites.select{ |favorite| favorite.blog_id === blog_params[:id] }.first
      favorite_blog.destroy! if favorite_blog
    end
  end
end
