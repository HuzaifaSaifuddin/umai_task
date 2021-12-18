class Api::V1::PostsController < ApplicationController
  before_action :find_user, only: [:create]

  def create
    # params[:post][:author_ip] = request.remote_ip
    post = @user.posts.new(post_params)

    if post.save
      render json: post, status: :created
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActionController::ParameterMissing => e
    render json: { errors: [e.message] }, status: :bad_request
  end

  def rate
    post = Post.find_by(id: params[:id])
    rating = post.ratings.new(value: params[:value])

    if rating.save
      new_average_rating = post.calculate_average_rating.to_f
      post.update(average_rating: new_average_rating)

      render json: { post_rating: new_average_rating }, status: :created
    else
      render json: { errors: rating.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def top_posts
    params[:limit] ||= 100
    posts = Post.all.order(average_rating: :desc).limit(params[:limit])

    render json: { posts: posts }, status: :ok
  end

  def ip_listing
    posts = Post.includes(:user).all
    ip_lists = posts.group_by(&:author_ip).map do |ip, posts|
      [ip, posts.map { |post| post.user.username }.uniq]
    end

    render json: { ip_list: ip_lists }, status: :ok
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :author_ip)
  end

  def find_user
    if params[:username]
      @user = User.find_by(username: params[:username].downcase)
      @user ||= User.create(username: params[:username])
    else
      render json: { errors: ["username is missing"] }, status: :bad_request
      return
    end
  end
end
