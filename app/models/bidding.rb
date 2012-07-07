class Bidding
  include Context

  attr_reader :bidder, :auction

  def self.make_bid user, auction
    bidding = Bidding.new user, auction
    bidding.make_bid
  end

  def initialize user, auction
    @bidder = user.extend Winner
    @auction = auction.extend AuctionUpdater
  end

  def make_bid
    in_context do
      return {auction: bidder.win}
    end
  rescue InvalidRecordException => e
    {errors: e.errors}
  end

  module Winner
    include ContextAccessor

    def win
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
