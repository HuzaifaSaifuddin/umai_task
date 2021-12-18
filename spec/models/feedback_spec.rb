require 'rails_helper'

RSpec.describe Feedback, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  it 'has a valid factory' do
    expect(build_stubbed(:feedback)).to be_valid
  end

  describe 'Validations' do
    it 'is invalid without a comment' do
      expect(build_stubbed(:feedback, comment: nil)).to be_invalid
    end
  end

  describe 'Relations' do
    it 'allows feedback to belong to user' do
      user = build_stubbed(:user)
      feedback_user = build_stubbed(:feedback, user: user)
      expect(feedback_user).to be_valid
      expect(feedback_user.user).to eq(user)
    end

    it 'allows feedback to belong to an entity user' do
      user = build_stubbed(:user)
      feedback_entity = build_stubbed(:feedback, entity: user)
      expect(feedback_entity).to be_valid
      expect(feedback_entity.entity).to eq(user)
    end

    it 'allows feedback to belong to an entity post' do
      post = build_stubbed(:post)
      feedback_entity = build_stubbed(:feedback, entity: post)
      expect(feedback_entity).to be_valid
      expect(feedback_entity.entity).to eq(post)
    end
  end
end
