class Bidding
  include Context
  EXTENDING_INTERVAL = 30.minutes

  class ValidationException < Exception; end

  def self.bid user, bid_params, listener
    auction = Auction.find(bid_params.auction_id)
    bidding = Bidding.new user, auction, bid_params, listener
    bidding.bid
  end

  def self.buy user, bid_params, listener
    auction = Auction.find(bid_params.auction_id)
    bid_params.amount = auction.buy_it_now_price
    bidding = Bidding.new user, auction, bid_params, listener
    bidding.bid
  end

  attr_reader :bidder, :biddable_auction, :bid_creator, :listener

  def initialize user, auction, bid_params, listener
    @bidder = user.extend Bidder
    @biddable_auction = auction.extend BiddableAuction
    @bid_creator = bid_params.extend BidCreator
    @listener = listener
  end

  def bid
    in_context do
      bidder.create_bid
    end
  rescue InvalidRecordException => e
    listener.create_on_error e.errors
  rescue ValidationException => e
    listener.create_on_error [e.message]
  end

  module Bidder
    include ContextAccessor

    def create_bid
      validate_bid
      context.biddable_auction.create_bid
    end

    def validate_bid
      validate_bidding_against_yourself
      context.biddable_auction.validate_status
      context.bid_creator.validate
    end

    def validate_bidding_against_yourself
      raise ValidationException, "Bidding against yourself is not allowed." if last_bidder?
    end

    def last_bidder?
      context.biddable_auction.last_bidder == self
    end
  end

  module BiddableAuction
    include ContextAccessor

    def validate_status
      raise ValidationException, "Bidding on closed auction is not allowed." unless started?
    end

    def last_bidder
      return nil unless last_bid
      last_bid.user
    end

    def create_bid
      bid = make_bid(context.bidder, context.bid_creator.amount)

      if purchasing? bid
        close_auction
        context.listener.create_on_success "Purchased successfully performed."

      elsif auction_must_be_extended?
        extend_auction
        context.listener.create_on_success "Your bid is accepted, and the auction has been extended for 30 minutes."

      else
        context.listener.create_on_success "Your bid is accepted."
      end
    end

    def purchasing? bid
      buy_it_now_price == bid.amount
    end

    def close_auction
      assign_winner context.bidder
    end

    def auction_must_be_extended?
      almost_closed = end_date - Time.now < EXTENDING_INTERVAL
      almost_closed and started?
    end

    def extend_auction
      extend_end_date_for EXTENDING_INTERVAL
    end
  end

  module BidCreator
    include ContextAccessor

    def validate
      validate_presence
      validate_against_last_bid
      validate_against_buy_it_now
    end

    def validate_presence
      raise ValidationException, validation_message unless valid?
    end

    def validation_message
      errors.full_messages.join(", ")
    end

    def validate_against_last_bid
      last_bid = context.biddable_auction.last_bid
      raise ValidationException, "The amount must be greater than the last bid." if last_bid && last_bid.amount >= amount
    end

    def validate_against_buy_it_now
      buy_it_now_price = context.biddable_auction.buy_it_now_price
      raise ValidationException, "Bid cannot exceed the buy it now price." if amount > buy_it_now_price
    end
  end
end
