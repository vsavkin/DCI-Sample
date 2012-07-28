class AuctionsController < ApplicationController
  def index
    @auctions = AuctionsPresenter.new(Auction.all, current_user, view_context)
  end

  def show
    auction_to_show = Auction.find(params[:id])
    @auction = AuctionPresenter.new(auction_to_show, current_user, view_context)
  end

  def new
  end

  def create
    result = CreatingAuction.create(current_user, auction_params)
    if success? result
      flash[:notice] = "Auction was successfully created."
      render :json => {auction_path: auction_path(result[:auction].id)}
    else
      render :json => {:errors => result[:errors]}, :status  => :unprocessable_entity
    end
  end

  private

  def auction_params
    AuctionParams.new(params[:auction_params])
  end
end
