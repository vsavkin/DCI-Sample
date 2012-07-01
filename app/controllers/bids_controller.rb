class BidsController < ApplicationController
  def create
    auction = Auction.find(params[:auction_id])
    result = make_bid auction
    if success? result
      flash[:notice] = "Purchased successfully performed"
      render :json => {auction_path: auction_path(result[:auction].id)}
    else
      render :json => {:errors => result[:errors]}, :status  => :unprocessable_entity
    end
  end

  private

  def make_bid auction
    Bidding.make_bid current_user, auction
  end
end
