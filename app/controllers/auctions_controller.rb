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
    result = create_auction(params[:auction_params])
    if success? result
      flash[:notice] = "Auction was successfully created."
      render :json => {auction_path: auction_path(result[:auction].id)}
    else
      render :json => {:errors => result[:errors]}, :status  => :unprocessable_entity
    end
  end

  def create_auction auction_params
    CreatingAuction.create current_user, AuctionParams.new(auction_params)
  end
end
