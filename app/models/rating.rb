class Rating
  include Mongoid::Document
  include Mongoid::Timestamps

  field :value, type: Float

  belongs_to :post

  validates :value, inclusion: { in: [1, 2, 3, 4, 5], message: 'should be 1, 2, 3, 4 or 5' }
end
