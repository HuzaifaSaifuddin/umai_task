# UMAI Assignment
#### _An Api Application to add post, feedbacks & rating_
- User can add Post
- User can rate the Post
- User can give feedback on the post or User

## Development
- This is a Ruby(2.7.3) on Rails(6.1.4) API only application.
- The database used is MongoDB (Gem mongoid).
- The application uses Rspec for test cases.

After cloning the repository. Execute the following steps in terminal.
```sh
cd <path-to-repo>
bundle install
rake db:seed
rails s # rails server
```
Your server will start at ```http://localhost:3000```

## Schema
- User
  - has_many Posts
  - has_many Feedbacks (Polymorphic as Entity)
- Post
  - belongs_to User
  - has_many Rating
  - has_many Feedbacks (Polymorphic as Entity)
- Rating
  - belongs_to Post
- Feedback
  - belongs_to User (Foreign Key - owner_id)
  - belongs_to Entity (Polymorphic with User & Post)

Note: Although MongoDB is a non-relational database, the ODM provided by Mongoid gem allows this to be possible. Behind the scenes the relations are stored in a non-relational way

## Testing
Test Cases are written using Rspec (with Faker, FactoryBot).
To run test cases on file(s) ```rspec .``` or ```rpsec spec/<filename>```

## API Endpoints
#### POSTS
Posts#Create - Create a Post
- If user with this username doesn't exist a new user will be created.
```
# POST http://localhost:3000/api/v1/posts
Body => {
  "username": "Huzaifa",
  "post": {
    "title": "New Post",
    "content": "New Post Content",
    "author_ip": "127.9.0.9"
  }
}
```

Posts#Rate - Create Rating for a Post
- Accepts value between 1 to 5
```
# POST http://localhost:3000/api/v1/posts/:id/rate
Body => {
  "value": "2"
}
```

Posts#top_posts - Show the tops post sorted by average_rating
- If no limit is set it loads upto 100 entries
```
# GET http://localhost:3000/api/v1/top_posts?limit=x
```

Posts#ip_listing - Returns a list of ips used to create post grouped by username
```
# GET http://localhost:3000/api/v1/ip_listing
```

#### FEEDBACKS
Feedbacks#Create - Create a Feedback for a User or a Post
```
# POST http://localhost:3000/api/v1/feedbacks
Body (user feedback) => {
  "user_id": :user_id,
  "feedback": {
    "comment": "This is a good user",
    "owner_id": :user_id
  }
}

Body (post feedback) => {
  "post_id": :post_id,
  "feedback": {
    "comment": "This is a good user",
    "owner_id": :user_id
  }
}
```

## Seed Data
The seed data is provided at ```./db/seed.rb```.
To run ```rake db:seed```

## Cron Job
The Cron Job to create XML file with Feedbacks is scheduled at 9:00 AM and can be found in ```config/schedule.rb```
To run the cron in development environment
```sh
# To update cron job
whenever --update-crontab --set environment=development
# To list all cron jobs in the system
crontab -l
```
The cron job run a rake file ```lib/tasks/feedback_xml_file.rake``` which creates the desired XML.
