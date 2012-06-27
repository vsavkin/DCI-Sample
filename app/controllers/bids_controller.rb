class BidsController < ApplicationController
  def create
    auction = Auction.find(params[:auction_id])
    Bidding.make_bid current_user, auction
  end
end