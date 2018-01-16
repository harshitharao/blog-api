require 'rails_helper'

RSpec.describe BlogsController, type: :controller do

  let(:valid_attributes) {
    {
      title: 'Sample blog',
      link: 'https://sample-blog.html'
    }
  }

  let(:invalid_attributes) {
    {
      title: '',
      link: 'https://sample-invalid-blog.html'
    }
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      blog = Blog.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      blog = Blog.create! valid_attributes
      get :show, params: {id: blog.to_param}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Blog" do
        expect {
          post :create, params: {blog: valid_attributes}, session: valid_session
        }.to change(Blog, :count).by(1)
      end

      it "renders a JSON response with the new blog" do
        post :create, params: {blog: valid_attributes}, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(blog_url(Blog.last))
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new blog" do
        post :create, params: {blog: invalid_attributes}, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end
end
