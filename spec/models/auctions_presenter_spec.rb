require 'model_spec_helper'

describe AuctionsPresenter do
  let(:current_user){User.new}
  let(:auctions){[Auction.new]}
  let(:presenter){AuctionsPresenter.new(auctions, current_user, stub)}

  it "should wrap passed auctions into a presenter" do
    presenter.count.should == 1
    presenter.first.class.should == AuctionPresenter
  end
end
