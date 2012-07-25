class BidsController < ApplicationController

  def create
    result = Bidding.bid(current_user, params[:auction_id], params[:amount])
    if success? result
      flash[:notice] = "Purchased successfully performed"
    else
      flash[:error] = result[:errors].join("\n")
    end
    redirect_to auction_path(params[:auction_id])
  end

  def buy
    result = Bidding.buy(current_user, params[:auction_id])
    if success? result
      flash[:notice] = "Purchased successfully performed"
    else
      flash[:error] = result[:errors].join("\n")
    end
    redirect_to auction_path(params[:auction_id])
  end
end
