require 'rails_helper'

RSpec.describe Favorite, type: :model do
  let(:valid_attributes) {
    {
      title: 'Sample blog',
      link: 'https://sample-blog.html',
      description: 'I want to change but my past haunts me, Swami,&#8221; a visitor said to me recently. &#8220;I constantly feel guilty for my sins. How do I get rid of my baggage.Two things will follow you to your grave. I replied. &#8220;Wanna guess?&#8221; And creditors,&#8221; I joked. He laughed a nervous laugh.That is not to say that there&#8217;s no way of shedding our past. ',
      content: 'Full content of blog<br>'
    }
  }
  let(:user) {User.create!(name: 'Test user', email: 'testuser@gmail.com', password: '123456')}
  let(:blog) {Blog.create! valid_attributes}

  describe '.is_favorite_blog' do
    it 'returns true if the blog is present under favorite for a specific user' do
      Favorite.create(blog_id: blog.id, user_id: user.id)

      expect(Favorite.is_favorite_blog(blog.id, user.id)).to eq(true)
    end

    it 'returns false if the blog is absent under favorite for the user' do
      another_blog = Blog.create! valid_attributes
      Favorite.create(blog_id: blog.id, user_id: user.id)

      expect(Favorite.is_favorite_blog(another_blog.id, user.id)).to eq(false)
    end
  end
end
