class Api::V1::FeedbacksController < ApplicationController
  before_action :find_entity, only: [:create]

  def create
    feedback = @entity.feedbacks.find_by(owner_id: params[:feedback][:owner_id])

    if feedback.nil?
      feedback = @entity.feedbacks.new(feedback_params)
      unless feedback.save
        render json: { errors: feedback.errors.full_messages }, status: :unprocessable_entity
        return
      end
    end

    owner_feedbacks = Feedback.where(owner_id: params[:feedback][:owner_id])
    render json: { owner_feedbacks: owner_feedbacks }, status: :created
  end

  private

  def feedback_params
    params.require(:feedback).permit(:comment, :owner_id)
  end

  def find_entity
    if params[:user_id]
      @entity = User.find_by(id: params[:user_id])
    elsif params[:post_id]
      @entity = Post.find_by(id: params[:post_id])
    else
      render json: { errors: ["user_id or post_id is required"] }, status: :bad_request
      return
    end

    if @entity.nil?
      render json: { errors: ["No User/Post exists with given id"] }, status: :bad_request
      return
    end
  end
end
