require 'rails_helper'

RSpec.describe 'Api::V1::Posts', type: :request do
  describe 'POST /create' do
    let(:feedback) { build(:feedback) }

    it 'creates a feedback (entity user)' do
      user = create(:user)
      post '/api/v1/feedbacks', headers: {},
                                params: { user_id: user.id.to_s,
                                          feedback: { comment: feedback.comment, owner_id: feedback.owner_id } }
      expect(response).to have_http_status(:created)
    end

    it 'creates a feedback (entity post)' do
      new_post = create(:post)
      post '/api/v1/feedbacks', headers: {},
                                params: { post_id: new_post.id.to_s,
                                          feedback: { comment: feedback.comment, owner_id: feedback.owner_id } }
      expect(response).to have_http_status(:created)
    end

    it 'doesnt create a feedback if entity is missing' do
      post '/api/v1/feedbacks', headers: {},
                                params: { feedback: { comment: feedback.comment, owner_id: feedback.owner_id } }
      expect(response).to have_http_status(:bad_request)
    end

    it 'doesnt create a feedback if comment/owner_id is missing' do
      new_post = create(:post)
      post '/api/v1/feedbacks', headers: {},
                                params: { post_id: new_post.id.to_s,
                                          feedback: { owner_id: feedback.owner_id } }
      expect(response).to have_http_status(:unprocessable_entity)

      post '/api/v1/feedbacks', headers: {},
                                params: { post_id: new_post.id.to_s,
                                          feedback: { comment: feedback.comment } }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'doesnt create a feedback if already exists' do
      feedback_one = build(:feedback, :entity_user)
      user = feedback_one.user
      entity = feedback_one.entity
      5.times do
        post '/api/v1/feedbacks', headers: {},
                                  params: { user_id: entity.id.to_s,
                                            feedback: { comment: feedback_one.comment, owner_id: feedback_one.owner_id } }
      end

      expect(Feedback.count).to eq(1)
    end
  end
end
