class BidParams
  include FormFriendly
  include Virtus

  attribute :amount, Decimal
  attribute :auction_id, Integer

  def self.empty
    BidParams.new({})
  end

  def == other
    attributes == other.attributes
  end
end
