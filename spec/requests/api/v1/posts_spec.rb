require 'rails_helper'

RSpec.describe 'Api::V1::Posts', type: :request do
  describe 'POST /create' do
    let(:new_post) do
      new_post = build(:post, user_id: nil).attributes
      new_post.each { |k, v| new_post[k] = v.to_s }
    end

    let(:user) { build(:user) }

    it 'returns the title' do
      post '/api/v1/posts', headers: nil, params: { post: new_post, username: user.username }
      expect(JSON.parse(response.body)['title']).to eq(new_post['title'])
    end

    it 'creates a post' do
      post '/api/v1/posts', headers: {}, params: { post: new_post, username: user.username }
      expect(response).to have_http_status(:created)
    end

    it 'creates a user if non-existent' do
      total_users = User.all.count
      post '/api/v1/posts', headers: {}, params: { post: new_post, username: user.username }
      expect(User.all.count).to eq(total_users + 1)
    end

    it 'raises validation error if title is empty' do
      new_post['title'] = ''

      post '/api/v1/posts', headers: {}, params: { post: new_post, username: user.username }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'raises ParameterMissing if post is missing or empty' do
      post '/api/v1/posts', headers: {}
      expect(response).to have_http_status(:bad_request)

      post '/api/v1/posts', headers: {}, params: { post: {}, username: user.username }
      expect(response).to have_http_status(:bad_request)
    end

    it 'raises ParameterMissing if username is missing' do
      post '/api/v1/posts', headers: {}, params: { post: { title: new_post['title'] } }
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'POST /rate' do
    let(:post_one) do
      create(:post)
    end

    it 'creates a rating' do
      post "/api/v1/posts/#{post_one.id}/rate", headers: {}, params: { value: 3 }
      expect(response).to have_http_status(:created)
    end

    it 'returns the average rating for that post' do
      post "/api/v1/posts/#{post_one.id}/rate", headers: {}, params: { value: 3 }
      expect(JSON.parse(response.body)['post_rating']).to eq(3.0)
    end

    it 'updates the average rating field of that post' do
      post "/api/v1/posts/#{post_one.id}/rate", headers: {}, params: { value: 3 }

      post_one.reload
      expect(post_one.average_rating).to eq(3)
    end

    it 'raises validation error if value is empty' do
      post "/api/v1/posts/#{post_one.id}/rate", headers: {}, params: {}
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET /top_posts' do
    it 'loads all the posts with status :ok' do
      get "/api/v1/posts/top_posts", headers: {}
      expect(response).to have_http_status(:ok)
    end

    it 'loads N number of posts if limit specified' do
      posts = create_list(:post, 5)
      ratings = create_list(:rating, 2, post: posts.sample)
      get "/api/v1/posts/top_posts", headers: {}, params: { limit: 3 }
      expect(JSON.parse(response.body)['posts'].length).to eq(3)
    end

    it 'loads N number of posts sorted by the average_rating' do
      ar_post_one = create(:post, average_rating: 3.5)
      ar_post_two = create(:post, average_rating: 1.75)
      get "/api/v1/posts/top_posts", headers: {}, params: { limit: 2 }
      posts = JSON.parse(response.body)['posts']
      expect(posts[0]['average_rating']).to eq(ar_post_one.average_rating)
      expect(posts[1]['average_rating']).to eq(ar_post_two.average_rating)
    end
  end

  describe 'GET /ip_listing' do
    it 'loads ip_list with users with status :ok' do
      get "/api/v1/posts/ip_listing", headers: {}
      expect(response).to have_http_status(:ok)
    end

    it 'returns a list of ips used to create post grouped by username' do
      create_list(:post, 5)
      ip_lists = Post.all.group_by(&:author_ip).map do |ip, posts|
        [ip, posts.map { |post| post.user.username }.uniq]
      end
      get "/api/v1/posts/ip_listing", headers: {}
      expect(JSON.parse(response.body)['ip_list']).to eq(ip_lists)
    end
  end
end
