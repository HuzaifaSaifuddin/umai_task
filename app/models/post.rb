class Post
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :content, type: String
  field :author_ip, type: String
  field :average_rating, type: Float, default: 0.0

  belongs_to :user

  has_many :ratings
  has_many :feedbacks, as: :entity

  validates_presence_of :title, :content, :author_ip

  def calculate_average_rating
    ratings.pluck(:value).average
  end
end
