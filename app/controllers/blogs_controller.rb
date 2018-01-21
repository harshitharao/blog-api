class BlogsController < ApplicationController
  skip_before_action :authenticate_request, only: [:show, :index]
  before_action :find_blog, only: [:show, :update]

  def index
    authenticate_request if request.headers['Authorization'].present?
    @blogs = Common.sort_by_date(Blog.all, :published_date)

    render json: @blogs, user: @current_user, show_details: false
  end

  def show
    authenticate_request if request.headers['Authorization'].present?
    render json: @blog, user: @current_user, show_details: true
  end

  def update
    if blog_params[:is_favorite]
      Favorite.create_or_delete(blog_params, @current_user)
      render json: { message: 'Successfully updated favorites' }, status: :ok
    else
      render json: { message: 'Unable to update blog favorites' }, status: :unprocessable_entity
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
