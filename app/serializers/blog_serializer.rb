class BlogSerializer < ActiveModel::Serializer
  attributes :id, :title, :link, :published_date, :is_new, :cover_image

  INITIAL_DESCRIPTION_SPLIT=30

  def attributes(user, details)
    if @instance_options[:show_details]
      @instance_options[:user] ? super.merge(content: object.content, is_favorite: is_favorite) : super.merge(content: object.content)
    else
      @instance_options[:user] ? super.merge(description: description, is_favorite: is_favorite) : super.merge(description: description)
    end
  end

  def description
    description_text = object.description
    initial_n_words = description_text[/(\s*\S+){#{INITIAL_DESCRIPTION_SPLIT}}/]
    return description_text unless initial_n_words

    description_text.slice!(initial_n_words)
    remaining_description = description_text.split('.')[0]
    initial_n_words + remaining_description
  end

  def is_new
    previous_midnight = DateTime.now.midnight - 1.day
    object.created_at >= previous_midnight
  end

  def is_favorite
    Favorite.is_favorite_blog(object.id, @instance_options[:user].id)
  end

  def cover_image
    object.cover_image || ActionController::Base.helpers.asset_path("default.jpg")
  end
end
