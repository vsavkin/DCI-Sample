class AuctionsController < ApplicationController
  def show
  end

  def new
  end

  def create
    auction_params = AuctionParams.new(params[:auction_params])
    result = CreateAuction.create current_user, auction_params

    if result.has_key? :errors
      render :status  => :unprocessable_entity, :json => result
    else
      render :json => {auction_path: auction_path(result[:auction])}
    end
  end
end