class Bidding
  include Context

  class ValidationException < Exception; end

  def self.bid user, bid_params
    auction = Auction.find(bid_params.auction_id)
    bidding = Bidding.new user, auction
    bidding.bid bid_params.amount
  end

  def self.buy user, bid_params
    auction = Auction.find(bid_params.auction_id)
    bidding = Bidding.new user, auction
    bidding.bid auction.buy_it_now_price
  end

  attr_reader :bidder, :biddable

  def initialize user, auction
    @bidder = user.extend Bidder
    @biddable = auction.extend Biddable
  end

  def bid amount
    in_context do
      bid = biddable.create_bid amount
      return {bid: bid}
    end
  rescue InvalidRecordException => e
    {errors: e.errors}
  rescue ValidationException => e
    {errors: [e.message]}
  end

  #seller cannot bid
  module Biddable
    include ContextAccessor

    def create_bid amount
      validate_bid amount
      bid = make_bid(context.bidder, amount)
      close_auction bid
      return bid
    end

    def validate_bid amount
      validate_status
      context.bidder.validate_bidding_against_yourself bids
      validate_against_amount amount
      validate_against_buy_it_now amount
    end

    def validate_status
      raise ValidationException, "Bidding on closed auction is not allowed." unless started?
    end

    def validate_against_amount amount
      return if bids.blank?
      raise ValidationException, "The amount must be greater than the last bid." if bids.last.amount >= amount
    end

    def validate_against_buy_it_now amount
      raise ValidationException, "Bid cannot exceed the buy it now price." if amount > buy_it_now_price
    end

    def close_auction bid
      assign_winner context.bidder if winning_bid? bid
    end

    def winning_bid? bid
      buy_it_now_price == bid.amount
    end
  end

  module Bidder
    include ContextAccessor

    def validate_bidding_against_yourself bids
      return if bids.blank?
      raise ValidationException, "Bidding against yourself is not allowed." if last_bidder?(bids)
    end

    def last_bidder? bids
      bids.last.user == self
    end
  end
end
