require 'rails_helper'

RSpec.describe Post, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  it 'has a valid factory' do
    expect(build_stubbed(:post)).to be_valid
  end

  describe 'Validations' do
    it 'is invalid without a title' do
      expect(build_stubbed(:post, title: nil)).to be_invalid
    end

    it 'is invalid without a content' do
      expect(build_stubbed(:post, content: nil)).to be_invalid
    end

    it 'is invalid without a author_ip' do
      expect(build_stubbed(:post, author_ip: nil)).to be_invalid
    end
  end

  describe 'Relations' do
    it 'allows post to have many rating' do
      post = create(:post)
      ratings = create_list(:rating, 2, post: post)
      expect(post).to be_valid
      expect(post.ratings.length).to eq(2)
    end

    it 'allows feedback to belong to an entity post' do
      post = build_stubbed(:post)
      post_feedbacks = build_stubbed(:post, :post_feedbacks)
      expect(post_feedbacks).to be_valid
      expect(post_feedbacks.feedbacks.length).to eq(2)
    end
  end

  describe 'Calculate Average Rating' do
    it 'calculates the average rating of the Post' do
      post = create(:post)
      ratings = create_list(:rating, 2, post: post)
      rating_average = post.ratings.pluck(:value).average.to_f
      expect(post.calculate_average_rating).to eq(rating_average)
    end
  end
end
