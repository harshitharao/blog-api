class Blog < ApplicationRecord
  validates_presence_of :title, :published_date, :description
end
