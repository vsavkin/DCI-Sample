class AuctionsPresenter
  include Enumerable

  def initialize auctions, current_user, view_context
    @auctions = auctions
    @current_user = current_user
    @view_context = view_context
  end

  def each
    @auctions.each do |a|
      yield AuctionPresenter.new(a, @current_user, @view_context)
    end
  end
end