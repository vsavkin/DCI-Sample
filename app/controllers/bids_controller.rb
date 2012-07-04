class Protocol
  class << self
    def message(name)
      @messages ||= []
      @messages << name
    end
    attr_reader :messages
  end

  def initialize(callbacks)
    @callbacks = callbacks
  end

  def method_missing(name, *args)
    super unless self.class.messages.include?(name)
    @callbacks[name].call(*args)
  end
end

class ResponseHandler < Protocol
  message :success
  message :failure
end


class BidsController < ApplicationController
  def create
    auction = Auction.find(params[:auction_id])
    make_bid(auction, self)
  end

  private

  def make_bid auction, response_handler
    Bidding.make_bid current_user, auction, response_handler
  end
end
