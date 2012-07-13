class Bidding
  include Context

  def self.make_bid user, auction_id
    auction = Auction.find(auction_id)
    bidding = Bidding.new user, auction
    bidding.make_bid
  end

  attr_reader :bidder, :auction

  def initialize user, auction
    @bidder = user.extend Bidder
    @auction = auction
  end

  def make_bid
    in_context do
      bidder.make_bid
      return {}
    end
  rescue InvalidRecordException => e
    {errors: e.errors}
  end

  module Bidder
    include ContextAccessor

    def make_bid
      context.auction.assign_winner self
    end
  end
end
