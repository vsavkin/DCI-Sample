class AuctionsController < ApplicationController
  def show
  end

  def new
  end

  def create
    result = create_auction(params[:auction_params])
    if success? result
      flash[:notice] = "Auction was successfully created."
      render :json => {auction_path: auction_path(result[:auction].id)}
    else
      render :json => {:errors => result[:errors]}, :status  => :unprocessable_entity
    end
  end

  private

  def success? result
    !result.has_key?(:errors)
  end

  def create_auction auction_params
    CreateAuction.create current_user, AuctionParams.new(auction_params)
  end
end