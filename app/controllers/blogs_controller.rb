class BlogsController < ApplicationController
  before_action :find_blog, only: [:show, :update]

  def index
    @blogs = Blog.all

    render json: @blogs, user: @current_user
  end

  def show
    render json: @blog, serializer: BlogDetailsSerializer, user: @current_user
  end

  def update
    Favorite.create_or_delete(blog_params, @current_user) if blog_params[:is_favorite]
  end

  private
    def find_blog
      @blog = Blog.find(params[:id])
    end

    def blog_params
      params.permit(:id, :title, :published_date, :description, :content, :link, :is_favorite)
    end
end
