class Bidding
  include Context

  attr_reader :bidder, :auction, :context, :response_handler

  def self.make_bid user, auction, context
    bidding = Bidding.new user, auction, context
    bidding.make_bid
  end

  def initialize user, auction, context
    @bidder = user.extend Buyer
    @auction = auction.extend AuctionUpdater
    @context = context
    @response_handler = ResponseHandler.new(
      :success => ->(result) do
        context.flash[:notice] = "Purchased successfully performed"
        context.render :json => {auction_path: context.auction_path(result[:auction].id)}
      end,
      :failure => ->(result) do
        context.render :json => {:errors => result[:errors]}, :status  => :unprocessable_entity
      end
      )
  end

  def make_bid
    in_context do
      response_handler.success({auction: bidder.buy_item})
    end
  rescue InvalidRecordException => e
    response_handler.failure(errors: e.errors)
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
