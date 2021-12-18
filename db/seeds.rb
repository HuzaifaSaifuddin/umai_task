puts Time.now.strftime('%I:%M:%S')
user_ids = []
100.times do |i|
  user = User.create(username: Faker::Internet.username + Faker::Number.number(digits: 10).to_s)

  if i % 2 != 0 # This will create 50 entries
    user.feedbacks.create(comment: Faker::Lorem.sentence(word_count: 10), user: user_ids.sample)
  end

  user_ids << user.id.to_s
end

ip_lists = []
50.times { ip_lists << Faker::Internet.ip_v4_address }

20000.times do |i|
  post = Post.create(title: Faker::Lorem.sentence(word_count: 2),
                     content: Faker::Lorem.sentence(word_count: 10),
                     author_ip: ip_lists.sample,
                     user_id: user_ids.sample)

  if i % 2 != 0 # This will create 10000 entries
    post.feedbacks.create(comment: Faker::Lorem.sentence(word_count: 10), user: user_ids.sample)
  end

  3.times do
    post.ratings.new(value: (1..5).to_a.sample).save
  end
end
puts Time.now.strftime('%I:%M:%S')
