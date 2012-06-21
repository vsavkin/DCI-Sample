class AuctionParams
  include FormFriendly
  include Virtus

  attribute :item_name, String
  attribute :item_description, String
  attribute :buy_it_now_price, Decimal

  def self.empty
    AuctionParams.new
  end
end