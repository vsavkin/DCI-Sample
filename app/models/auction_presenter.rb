class AuctionPresenter
  extend Forwardable

  def_delegator :@item, :name, :item_name
  def_delegator :@item, :description, :item_description
  def_delegator :@seller, :name, :seller_name

  def_delegators :@auction, :buy_it_now_price, :id, :created_at

  def initialize auction
    @auction = auction
    @item = auction.item
    @seller = auction.seller
  end
end