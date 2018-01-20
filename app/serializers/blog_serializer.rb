class BlogSerializer < ActiveModel::Serializer
  attributes :id, :title, :link, :description, :published_date, :is_new, :is_favorite

  INITIAL_DESCRIPTION_SPLIT=30

  def description
    description_text = object.description
    initial_n_words = description_text[/(\s*\S+){#{INITIAL_DESCRIPTION_SPLIT}}/]
    return description_text unless initial_n_words

    description_text.slice!(initial_n_words)
    remaining_description = description_text.split('.')[0]
    initial_n_words + remaining_description
  end

  def is_new
    object.created_at >= DateTime.now.midnight - 1.day
  end

  def is_favorite
    Favorite.is_favorite_blog(object.id, @instance_options[:user].id)
  end
end
