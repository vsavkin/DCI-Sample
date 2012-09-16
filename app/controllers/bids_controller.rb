class BidsController < ApplicationController

  def create
    Bidding.bid(current_user, bid_params, self)
  end

  def buy
    Bidding.buy(current_user, bid_params, self)
  end

  def create_on_success
    flash[:notice] = "Your bid is accepted."
    redirect_to auction_path(params[:auction_id])
  end

  def create_on_error errors
    flash[:error] = errors.join("\n")
    redirect_to auction_path(params[:auction_id])
  end

  private

  def bid_params
    p = {auction_id: params[:auction_id]}
    p = p.merge(params[:bid_params]) if params[:bid_params]
    BidParams.new(p)
  end
end
