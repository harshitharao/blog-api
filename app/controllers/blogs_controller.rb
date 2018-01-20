class BlogsController < ApplicationController
  before_action :find_blog, only: [:show, :update]

  def index
    @blogs = Blog.all

    render json: @blogs, user: @current_user
  end

  def show
    render json: @blog, serializer: BlogDetailsSerializer, user: @current_user
  end

  def create
    @blog = Blog.new(blog_params)

    if @blog.save
      render json: @blog, status: :created, location: @blog
    else
      render json: @blog.errors, status: :unprocessable_entity
    end
  end

  def update
    if blog_params[:is_favorite] === 'true'
      Favorite.create!(blog_id: blog_params[:id], user_id: @current_user.id) if Favorite.where(blog_id: blog_params[:id], user_id: @current_user.id).empty?
    else
      favorite_blog = @current_user.favorites.select{ |favorite| favorite.blog_id === blog_params[:id] }.first
      favorite_blog.destroy! if favorite_blog
    end
  end

  private
    def find_blog
      @blog = Blog.find(params[:id])
    end

    def blog_params
      params.permit(:id, :title, :published_date, :description, :content, :link, :is_favorite)
    end
end
