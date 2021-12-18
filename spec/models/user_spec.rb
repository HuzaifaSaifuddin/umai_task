require 'rails_helper'

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  it 'has a valid factory' do
    expect(build_stubbed(:user)).to be_valid
  end

  describe 'Validations' do
    it 'is invalid without a username' do
      expect(build_stubbed(:user, username: nil)).to be_invalid
    end
  end

  describe 'Relations' do
    it 'allows user to have many posts' do
      user_posts = build_stubbed(:user, :user_posts)
      expect(user_posts).to be_valid
      expect(user_posts.posts.length).to eq(2)
    end

    it 'allows user to have many feedbacks' do
      user_feedbacks = build_stubbed(:user, :user_feedbacks)
      expect(user_feedbacks).to be_valid
      expect(user_feedbacks.feedbacks.length).to eq(2)
    end
  end
end
