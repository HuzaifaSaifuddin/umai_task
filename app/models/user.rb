class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :username, type: String

  has_many :posts
  has_many :feedbacks, as: :entity

  validates_presence_of :username
end
