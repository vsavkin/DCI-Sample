class AuctionsPresenter
  include Enumerable

  def initialize auctions
    @auctions = auctions
  end

  def each
    @auctions.each do |a|
      yield AuctionPresenter.new(a)
    end
  end
end