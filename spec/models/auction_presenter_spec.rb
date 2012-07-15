require 'model_spec_helper'

describe AuctionsPresenter do

  context "actions" do
    let(:seller){User.new}
    let(:buyer){User.new}
    let(:auction){Auction.new seller: seller, status: Auction::STARTED}

    context "but it now button" do
      it "should be rendered" do
        presenter = AuctionPresenter.new(auction, buyer, FakeViewContext.new)
        presenter.render_actions.should include("Buy It Now")
      end

      it "shouldn't not be rendered for the seller" do
        presenter = AuctionPresenter.new(auction, seller, FakeViewContext.new)
        presenter.render_actions.should_not include("Buy It Now")
      end

      it "shouldn't not be rendered when auction is closed" do
        auction.status = Auction::CLOSED

        presenter = AuctionPresenter.new(auction, buyer, FakeViewContext.new)
        presenter.render_actions.should_not include("Buy It Now")
      end
    end
  end

  class FakeViewContext
    def link_to *args
      args.first
    end

    def method_missing name, *args
      "blah blah blah"
    end
  end
end
