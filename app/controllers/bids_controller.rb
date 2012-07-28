class BidsController < ApplicationController

  def create
    result = Bidding.bid(current_user, bid_params)
    if success? result
      flash[:notice] = "Your bid is accepted"
    else
      flash[:error] = result[:errors].join("\n")
    end
    redirect_to auction_path(params[:auction_id])
  end

  def buy
    result = Bidding.buy(current_user, bid_params)
    if success? result
      flash[:notice] = "Purchased successfully performed"
    else
      flash[:error] = result[:errors].join("\n")
    end
    redirect_to auction_path(params[:auction_id])
  end

  private

  def bid_params
    p = {auction_id: params[:auction_id]}
    p = p.merge(params[:bid_params]) if params[:bid_params]
    BidParams.new(p)
  end
end
