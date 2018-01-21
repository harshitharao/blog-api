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

  describe '.create_or_delete' do
    context 'create' do
      it 'creates favorite blog for the user when is_favorite is true with string' do
        expect(Favorite.where(user_id: user.id, blog_id: blog.id)[0].present?).to be_falsey

        blog_params = { id: blog.id, is_favorite: 'true' }
        Favorite.create_or_delete(blog_params, user)

        expect(Favorite.where(user_id: user.id, blog_id: blog.id)[0].present?).to be_truthy
      end

      it 'creates favorite blog for the user when passed as boolean true' do
        expect(Favorite.where(user_id: user.id, blog_id: blog.id)[0].present?).to be_falsey

        blog_params = { id: blog.id, is_favorite: true }
        Favorite.create_or_delete(blog_params, user)

        expect(Favorite.where(user_id: user.id, blog_id: blog.id)[0].present?).to be_truthy
      end

      it 'does not create favorite blog for the user when it is already marked as favorite' do
        Favorite.create!(blog_id: blog.id, user_id: user.id)
        expect(Favorite.where(user_id: user.id, blog_id: blog.id).count).to eq(1)

        blog_params = { id: blog.id, is_favorite: true }
        Favorite.create_or_delete(blog_params, user)
        expect(Favorite.where(user_id: user.id, blog_id: blog.id).count).to eq(1)
      end
    end

    context 'delete' do
      it 'delete favorite blog for the user when passed as false' do
        Favorite.create!(blog_id: blog.id, user_id: user.id)
        expect(user.favorites[0].present?).to be_truthy

        blog_params = { id: blog.id, is_favorite: false }
        Favorite.create_or_delete(blog_params, user)

        expect(Favorite.where(user_id: user.id, blog_id: blog.id)[0].present?).to be_falsey
      end

      it 'does not delete any favorite when it is already deleted' do
        expect(Favorite.where(user_id: user.id, blog_id: blog.id)[0].present?).to be_falsey

        blog_params = { id: blog.id, is_favorite: false }
        Favorite.create_or_delete(blog_params, user)
        expect(Favorite.where(user_id: user.id, blog_id: blog.id)[0].present?).to be_falsey
      end
    end
  end
end
