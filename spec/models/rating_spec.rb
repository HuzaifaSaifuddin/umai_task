require 'rails_helper'

RSpec.describe Rating, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  it 'has a valid factory' do
    expect(build_stubbed(:rating)).to be_valid
  end

  describe 'Validations' do
    it 'is invalid without a value' do
      expect(build_stubbed(:rating, value: nil)).to be_invalid
    end

    it 'is invalid if value out of range' do
      expect(build_stubbed(:rating, value: 10)).to be_invalid
    end
  end

  describe 'Relations' do
    it 'allows rating to belong to post' do
      post = build_stubbed(:post)
      rating_post = build_stubbed(:rating, post: post)
      expect(rating_post).to be_valid
      expect(rating_post.post).to eq(post)
    end
  end

  describe 'update_post_average_rating' do
    it 'updates the posts average rating' do
      post = create(:post)
      ratings = create_list(:rating, 5, post: post)
      rating_average = ratings.pluck(:value).average.to_f
      expect(post.average_rating).to eq(rating_average)
    end
  end
end
