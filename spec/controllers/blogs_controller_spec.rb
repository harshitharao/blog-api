require 'rails_helper'

RSpec.describe BlogsController, type: :controller do

  let(:valid_attributes) {
    {
      title: 'Sample blog',
      link: 'https://sample-blog.html',
      description: 'I want to change but my past haunts me, Swami,&#8221; a visitor said to me recently. &#8220;I constantly feel guilty for my sins. How do I get rid of my baggage.Two things will follow you to your grave. I replied. &#8220;Wanna guess?&#8221; And creditors,&#8221; I joked. He laughed a nervous laugh.That is not to say that there&#8217;s no way of shedding our past. ',
      content: 'Full content of blog<br>',
      published_date: DateTime.now.midnight - 1.day
    }
  }

  let(:invalid_attributes) {
    {
      title: '',
      link: 'https://sample-invalid-blog.html'
    }
  }

  let(:user) {User.create!(name: 'Test user', email: 'testuser@gmail.com', password: '123456')}
  let(:blog) {Blog.create! valid_attributes}

  describe "GET #index" do
    context 'with authentication' do
      before(:each) do
        @token = AuthenticateUser.call(user.email,user.password).result
        @headers = { HTTP_AUTHORIZATION: @token }
        request.headers.merge! @headers
      end

      it "returns a success response with blog attributes except content" do
        blog = Blog.create! valid_attributes
        get :index, params: {}
        response_body = JSON.parse(response.body)
        expect(response).to be_success
        first_response = response_body[0]
        expect(first_response['title']).to eq('Sample blog')
        expect(first_response['link']).to eq('https://sample-blog.html')
        expect(first_response['description']).to eq('I want to change but my past haunts me, Swami,&#8221; a visitor said to me recently. &#8220;I constantly feel guilty for my sins. How do I get rid of my baggage')
        expect(first_response['published_date'].present?).to be_truthy
        expect(first_response['is_new']).to eq(true)
        expect(first_response['is_favorite']).to eq(false)
        expect(first_response['content']).to eq(nil)
      end
    end

    context 'without authentication' do
      it "returns a success response with blog attributes except is_favorite" do
        blog = Blog.create! valid_attributes
        get :index, params: {}
        response_body = JSON.parse(response.body)
        expect(response).to be_success
        first_response = response_body[0]
        expect(first_response['title']).to eq('Sample blog')
        expect(first_response['link']).to eq('https://sample-blog.html')
        expect(first_response['description']).to eq('I want to change but my past haunts me, Swami,&#8221; a visitor said to me recently. &#8220;I constantly feel guilty for my sins. How do I get rid of my baggage')
        expect(first_response['published_date'].present?).to be_truthy
        expect(first_response['is_new']).to eq(true)
        expect(first_response['is_favorite']).to eq(nil)
        expect(first_response['content']).to eq(nil)
      end
    end

    context 'is_new with latest blogs sorted' do
      it "returns latest blogs in order along with new blogs as marked" do
        old_sample = Blog.create! valid_attributes
        new_sample = Blog.create! valid_attributes
        another_new_sample = Blog.create! valid_attributes

        old_sample.created_at = DateTime.now.midnight - 2.day
        old_sample.title = 'Old sample blog'
        old_sample.save

        new_sample.created_at = DateTime.now.midnight - 1.day
        new_sample.save

        another_new_sample.created_at = DateTime.now
        another_new_sample.title = 'Another new sample blog'
        another_new_sample.save

        get :index, params: {}
        response_body = JSON.parse(response.body)
        expect(response_body[0]['title']).to eq('Another new sample blog')
        expect(response_body[1]['title']).to eq('Sample blog')
        expect(response_body[2]['title']).to eq('Old sample blog')
        expect(response_body[0]['is_new']).to eq(true)
        expect(response_body[1]['is_new']).to eq(true)
        expect(response_body[2]['is_new']).to eq(false)
      end
    end

    context 'description' do
      it "returns blogs having description around 30 words" do
        blog = Blog.create! valid_attributes
        get :index
        response_body = JSON.parse(response.body)
        expect(response_body[0]['description']).to eq('I want to change but my past haunts me, Swami,&#8221; a visitor said to me recently. &#8220;I constantly feel guilty for my sins. How do I get rid of my baggage')
      end

      it "returns blogs having description as is if it has less than 30 words" do
        blog.description = 'small desc'
        blog.save

        get :index
        response_body = JSON.parse(response.body)
        expect(response_body[0]['description']).to eq('small desc')
      end
    end
  end

  describe "GET #show" do
    context 'with authentication' do
      before(:each) do
        @token = AuthenticateUser.call(user.email,user.password).result
        @headers = { HTTP_AUTHORIZATION: @token }
        request.headers.merge! @headers
      end

      it "returns a success response with blog attributes except description" do
        get :show, params: {id: blog.to_param}
        response_body = JSON.parse(response.body)
        expect(response).to be_success
        expect(response_body['title']).to eq('Sample blog')
        expect(response_body['link']).to eq('https://sample-blog.html')
        expect(response_body['content']).to eq('Full content of blog<br>')
        expect(response_body['published_date'].present?).to be_truthy
        expect(response_body['is_new']).to eq(true)
        expect(response_body['is_favorite']).to eq(false)
        expect(response_body['description']).to eq(nil)
      end
    end

    context 'without authentication' do
      it "returns content without description and is_favorite" do
        get :show, params: {id: blog.to_param}
        response_body = JSON.parse(response.body)
        expect(response_body['content']).to eq('Full content of blog<br>')
        expect(response_body['description']).to eq(nil)
        expect(response_body['is_favorite']).to eq(nil)
      end
    end
  end

  describe "PUT #update" do
    context 'with authentication' do
      before(:each) do
        @token = AuthenticateUser.call(user.email,user.password).result
        @headers = { HTTP_AUTHORIZATION: @token }
        request.headers.merge! @headers
      end

      context "with valid params" do
        it "updates current blog to be favorite on passing is_favorite as true" do
          put :update, params: {id: blog.to_param, is_favorite: true}
          expect(response).to have_http_status(:ok)
          expect(Favorite.where(user_id: user.id, blog_id: blog.id)[0].present?).to be_truthy
        end

        it "unmark current blog to not be favorite on passing is_favorite as false" do
          put :update, params: {id: blog.to_param, is_favorite: true}
          expect(Favorite.where(user_id: user.id, blog_id: blog.id)[0].present?).to be_truthy

          put :update, params: {id: blog.to_param, is_favorite: false}
          expect(response).to have_http_status(:ok)
          expect(Favorite.where(user_id: user.id, blog_id: blog.id)[0].present?).to be_falsey
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the blog update" do
          put :update, params: {id: blog.id}
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
          expect(Favorite.where(user_id: user.id, blog_id: blog.id)[0].present?).to be_falsey
        end
      end
    end

    context 'without authentication' do
      it "returns unauthorized" do
        put :update, params: {id: blog.to_param, is_favorite: true}
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
