class Bidding
  include Context

  attr_reader :bidder, :auction

  def self.make_bid user, auction
    bidding = Bidding.new user, auction
    bidding.make_bid
  end

  def initialize user, auction
    @bidder = user.extend Buyer
    @auction = auction.extend AuctionUpdater
  end

  def make_bid
    in_context do
      return {auction: bidder.buy_item}
    end
  rescue InvalidRecordException => e
    {errors: e.errors}
  end

  module Buyer
    include ContextAccessor

    def buy_item
      context.auction.close_auction self
    end
  end

  module AuctionUpdater
    include ContextAccessor

    def close_auction buyer
      self.assign_buyer buyer
    end
  end
end
