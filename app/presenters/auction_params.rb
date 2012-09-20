class AuctionParams
  include FormFriendly
  include Virtus

  attribute :item_name, String
  attribute :item_description, String
  attribute :buy_it_now_price, Decimal
  attribute :end_date, DateTime
  attribute :extendable, Boolean

  def self.empty
    AuctionParams.new({})
  end

  def == other
    attributes == other.attributes
  end
end
