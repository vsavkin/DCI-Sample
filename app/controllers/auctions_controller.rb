class AuctionsController < ApplicationController
  def show
  end

  def new
  end

  def create
    auction_params = AuctionParams.new(params[:auction_params])
    auction = CreateAuction.create current_user, auction_params
    redirect_to auction_path(auction)
  end
end