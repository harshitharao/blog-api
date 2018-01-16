require 'rails_helper'

RSpec.describe BlogsController, type: :controller do

  let(:valid_attributes) {
    {
      title: 'Sample blog',
      link: 'https://sample-blog.html',
      description: 'I want to change but my past haunts me, Swami,&#8221; a visitor said to me recently. &#8220;I constantly feel guilty for my sins. How do I get rid of my baggage.Two things will follow you to your grave. I replied. &#8220;Wanna guess?&#8221; And creditors,&#8221; I joked. He laughed a nervous laugh.That is not to say that there&#8217;s no way of shedding our past. '
    }
  }

  let(:invalid_attributes) {
    {
      title: '',
      link: 'https://sample-invalid-blog.html'
    }
  }

  describe "GET #index" do
    it "returns a success response" do
      blog = Blog.create! valid_attributes
      get :index, params: {}
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      blog = Blog.create! valid_attributes
      get :show, params: {id: blog.to_param}
      expect(response).to be_success
    end

    it "returns blog having description around 30 words" do
      blog = Blog.create! valid_attributes
      get :show, params: {id: blog.to_param}
      response_body = JSON.parse(response.body)
      expect(response_body['description']).to eq('I want to change but my past haunts me, Swami,&#8221; a visitor said to me recently. &#8220;I constantly feel guilty for my sins. How do I get rid of my baggage')
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Blog" do
        expect {
          post :create, params: {blog: valid_attributes}
        }.to change(Blog, :count).by(1)
      end

      it "renders a JSON response with the new blog" do
        post :create, params: {blog: valid_attributes}
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(blog_url(Blog.last))
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new blog" do
        post :create, params: {blog: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end
end
