class CreatingAuction
  include Context

  attr_reader :seller, :auction_creator

  def self.create user, auction_params
    c = CreatingAuction.new user, auction_params
    c.create
  end

  def initialize user, auction_params
    @seller = user.extend Seller
    @auction_creator = auction_params.extend AuctionCreator
  end

  def create
    in_context do
      return {auction: seller.start_auction}
    end
  rescue InvalidRecordException => e
    {errors: e.errors}
  end

  module Seller
    include ContextAccessor

    def start_auction
      auction = context.auction_creator.create_auction self
      auction.start
      auction
    end
  end

  module AuctionCreator
    include ContextAccessor

    def create_auction seller
      item = create_item
      Auction.make(seller, item, buy_it_now_price)
    end

    def create_item
      Item.make(item_name, item_description)
    end
  end
end
