class BidParams
  include FormFriendly
  include Virtus
  include ActiveModel::Validations

  attribute :amount, Decimal
  attribute :auction_id, Integer

  validates :amount, numericality: {greater_than: 0}

  def self.empty
    BidParams.new({})
  end

  def == other
    attributes == other.attributes
  end
end
