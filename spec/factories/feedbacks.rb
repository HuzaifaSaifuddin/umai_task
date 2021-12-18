FactoryBot.define do
  factory :feedback do
    comment { Faker::Lorem.sentence(word_count: 10) }
    user { create(:user) }
    entity { [create(:post), create(:user)].sample }
  end
end
