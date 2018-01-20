class BlogDetailsSerializer < ActiveModel::Serializer
  attributes :title, :published_date, :content, :is_new

  def is_new
    object.created_at >= DateTime.now.midnight - 1.day
  end
end
