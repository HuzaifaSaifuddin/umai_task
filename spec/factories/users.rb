FactoryBot.define do
  factory :user do
    username { Faker::Internet.username }
  end

  trait :user_posts do
    posts { create_list(:post, 2) }
  end

  trait :user_feedbacks do
    feedbacks { create_list(:feedback, 2) }
  end
end
