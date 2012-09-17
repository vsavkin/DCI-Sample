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
    CreatingAuction.create(current_user, auction_params, self)
  end

  def create_on_success auction_id
    flash[:notice] = "Auction was successfully created."
    render json: {auction_path: auction_path(auction_id)}
  end

  def create_on_error errors
    render json: {:errors => errors}, status: :unprocessable_entity
  end

  private

  def auction_params
    AuctionParams.new(params[:auction_params])
  end
end
