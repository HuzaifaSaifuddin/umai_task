FactoryBot.define do
  factory :rating do
    value { (1..5).to_a.sample.to_f }
    post { build_stubbed(:post) }
  end
end
