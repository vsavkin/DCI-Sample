class AuctionPresenter
  extend Forwardable

  def_delegator :@item, :name, :item_name
  def_delegator :@item, :description, :item_description
  def_delegator :@seller, :name, :seller_name

  def_delegators :@auction, :buy_it_now_price, :id, :created_at, :extendable, :end_date

  def initialize auction, current_user, view_context
    @auction = auction

    @item = auction.item
    @seller = auction.seller
    @winner = auction.winner

    @view_context = view_context
    @current_user = current_user
  end

  def render_winner
    return "" unless @winner
    h.content_tag :p do
      h.content_tag(:b, "Winner") +
      h.tag(:br) +
      h.content_tag(:span, @winner.name, id: "winner")
    end
  end

  def render_last_bid
    return "" unless @auction.last_bid
    h.content_tag :p do
      h.content_tag(:b, "Last Bid") +
      h.tag(:br) +
      @auction.last_bid.amount.to_s
    end
  end

  def render_all_bids
    return "" unless seller?
    h.content_tag :ul, id: "bids" do
      h.content_tag(:h3, "All Bids") + all_bids
    end
  end

  def render_actions
    "".tap do |res|
      res << render_bid_button if can_bid?
      res << render_buy_it_now_button if can_bid?
    end.html_safe
  end

  private

  def all_bids
    @auction.bids.map do |bid|
      h.content_tag :li do
        "#{bid.user.name} $#{bid.amount}"
      end.html_safe
    end.join("").html_safe
  end

  def seller?
    @auction.seller == @current_user
  end

  def can_bid?
    @auction.started? && @auction.seller != @current_user
  end

  def render_buy_it_now_button
    h.link_to "Buy It Now!", h.buy_auction_bids_path(id), class: "btn", method: "POST", id: "buy_it_now"
  end

  def render_bid_button
    h.render partial: "bid", locals: {auction_id: id}
  end

  def h
    @view_context
  end
end
