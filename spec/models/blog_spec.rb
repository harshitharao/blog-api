require 'rails_helper'

RSpec.describe Blog, type: :model do
  describe '#validations' do
    it 'should validate presence of title' do
      blog = Blog.create
      blog.valid?
      expect(blog.errors[:title][0]).to eq("can't be blank")

      blog.title = 'sample blog'
      blog.valid?
      expect(blog.errors[:title][0]).to eq(nil)
    end
  end
end
