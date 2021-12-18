FactoryBot.define do
  factory :feedback do
    comment { Faker::Lorem.sentence(word_count: 10) }
    user { create(:user) }

    # Default to Post
    entity_post

    trait :entity_post do
      entity { create(:post) }
    end

    trait :entity_user do
      entity { create(:user) }
    end
  end
end
