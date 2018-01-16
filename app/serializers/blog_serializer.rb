class BlogSerializer < ActiveModel::Serializer
  attributes :title, :link, :description
end
