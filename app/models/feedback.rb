class Feedback
  include Mongoid::Document
  include Mongoid::Timestamps

  field :comment, type: String

  belongs_to :user, foreign_key: :owner_id
  belongs_to :entity, polymorphic: true

  validates_presence_of :comment
end
