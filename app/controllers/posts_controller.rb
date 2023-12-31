# app/controllers/posts_controller.rb
require 'csv'
require 'faker'

class PostsController < ApplicationController
  before_action :set_user
  before_action :set_post, only: %i[show update destroy]
  def create_csv
    posts = @user.posts
    csv_data = CSV.generate(headers: true) do |csv|
      csv << ['Title', 'Content', 'Created At']

      posts.each do |post|
        csv << [post.title, post.content, post.created_at]
      end
    end

    send_data csv_data, filename: "user_#{params[:user_id]}_posts.csv", type: 'text/csv', disposition: 'attachment'
    # render body: nil
  end

  def index
    posts = @user.posts
  
    if posts.empty?
      render json: { message: "User has not created any posts yet" }, status: :ok
    else
      render json: posts, status: :ok
    end
  end

  def show
    if @post
      render json: @post, status: :ok
    else
      render json: { error: 'Post not found' }, status: :not_found
    end
  end

  def create
    post = @user.posts.new(post_params)
    if post.save
      render json: post, status: :created
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @post
      if @post.update(post_params)
        render json: @post, status: :ok
      else
        render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Post not found' }, status: :not_found
    end
  end

  def destroy
    if @post
      @post.destroy
      head :no_content
    else
      render json: { error: 'Post not found' }, status: :not_found
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :content)
  end

  def set_user
    @user = User.find_by(id: params[:user_id])
    render json: { error: 'User not found' }, status: :not_found unless @user
  end

  def set_post
    @post = @user.posts.find_by(id: params[:id])
  end
end
