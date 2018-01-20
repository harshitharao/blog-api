class BlogDetailsSerializer < ActiveModel::Serializer
  attributes :id, :title, :published_date, :content, :is_new, :is_favorite

  def is_new
    object.created_at >= DateTime.now.midnight - 1.day
  end

  def is_favorite
    Favorite.is_favorite_blog(object.id, @instance_options[:user].id)
  end
end
