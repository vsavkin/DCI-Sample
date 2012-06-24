require 'model_spec_helper'

describe AuctionsPresenter do
  let(:auctions){[Auction.new]}
  let(:presenter){AuctionsPresenter.new(auctions)}

  it "should wrap passed auctions into a presenter" do
    presenter.count.should == 1
    presenter.first.class.should == AuctionPresenter
  end
end
