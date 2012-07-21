class AuctionPresenter
  extend Forwardable

  def_delegator :@item, :name, :item_name
  def_delegator :@item, :description, :item_description
  def_delegator :@seller, :name, :seller_name

  def_delegators :@auction, :buy_it_now_price, :id, :created_at, :end_date

  def initialize auction, current_user, view_context
    @auction = auction
    @item = auction.item
    @seller = auction.seller
    @winner = auction.winner

    @view_context = view_context
    @current_user = current_user
  end

  def winner_name
    @winner.try(:name)
  end

  def render_actions
    "".tap do |res|
      res << render_buy_it_now_button if can_buy_it_now?
    end.html_safe
  end

  private

  def can_buy_it_now?
    @auction.started? && @auction.seller != @current_user
  end

  def render_buy_it_now_button
    h.link_to "Buy It Now!", h.auction_bids_path(id), class: "btn", method: "POST", id: "buy_it_now"
  end

  def h
    @view_context
  end
end
