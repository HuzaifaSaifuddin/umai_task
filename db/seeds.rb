ip_lists = []
50.times { ip_lists << Faker::Internet.ip_v4_address }

100.times do
  User.create(username: Faker::Internet.username + Faker::Number.number(digits: 10).to_s)
end

users = User.all.to_a
user_ids = users.pluck(:id)

20000.times do
  Post.create(title: Faker::Lorem.sentence(word_count: 2),
              content: Faker::Lorem.sentence(word_count: 10),
              author_ip: Faker::Internet.ip_v4_address,
              user_id: user_ids.sample)
end

posts = Post.all.to_a

10000.times do
  posts.sample.feedbacks.create(comment: Faker::Lorem.sentence(word_count: 10), user: users.sample)
end

50.times do
  users.sample.feedbacks.create(comment: Faker::Lorem.sentence(word_count: 10), user: users.sample)
end
