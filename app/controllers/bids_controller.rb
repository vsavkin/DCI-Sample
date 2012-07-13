class BidsController < ApplicationController

  def create
    result = make_bid params[:auction_id]
    if success? result
      flash[:notice] = "Purchased successfully performed"
    else
      flash[:error] = result[:errors].join("\n")
    end
    redirect_to auction_path(params[:auction_id])
  end

  private

  def make_bid auction_id
    Bidding.make_bid current_user, auction_id
  end
end
