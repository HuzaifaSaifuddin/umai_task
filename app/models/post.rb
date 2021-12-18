class Post
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :content, type: String
  field :author_ip, type: String

  belongs_to :user

  has_many :ratings
  has_many :feedbacks, as: :entity

  validates_presence_of :title, :content, :author_ip
end
