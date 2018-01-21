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

    it 'should validate presence of description' do
      blog = Blog.create
      blog.valid?
      expect(blog.errors[:description][0]).to eq("can't be blank")

      blog.description = 'sample blog description'
      blog.valid?
      expect(blog.errors[:description][0]).to eq(nil)
    end

    it 'should validate presence of published_date' do
      blog = Blog.create
      blog.valid?
      expect(blog.errors[:published_date][0]).to eq("can't be blank")

      blog.published_date = DateTime.now.midnight - 1.day
      blog.valid?
      expect(blog.errors[:published_date][0]).to eq(nil)
    end

    it 'should validate presence of published_date if title and description are present' do
      blog = Blog.create(title: 'Sample blog', description: 'Blog desc')
      expect(blog.valid?).to be_falsey
      expect(blog.errors[:published_date][0]).to eq("can't be blank")

      blog.published_date = DateTime.now.midnight - 1.day
      expect(blog.valid?).to be_truthy
      expect(blog.errors[:published_date][0]).to eq(nil)
    end
  end
end
