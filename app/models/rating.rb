class Rating
  include Mongoid::Document
  include Mongoid::Timestamps

  field :value, type: Integer

  belongs_to :post

  validates :value, inclusion: 1..5
end
