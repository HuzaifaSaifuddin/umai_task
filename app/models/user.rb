class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :username, type: String

  has_many :posts
  has_many :feedbacks, as: :entity

  validates_presence_of :username
  validates_uniqueness_of :username

  before_validation :downcase_username

  private

  def downcase_username
    self.username = username.downcase if username.present?
  end
end
