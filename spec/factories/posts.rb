FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence(word_count: 2) }
    content { Faker::Lorem.sentence(word_count: 10) }
    author_ip { Faker::Internet.ip_v4_address }
    user { create(:user) }
  end

  trait :post_feedbacks do
    feedbacks { create_list(:feedback, 2) }
  end
end
