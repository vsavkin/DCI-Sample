require 'model_spec_helper'

describe Bidding do
  let(:auction){double("Auction")}
  let(:bidder){User.new}

  context "buying" do
    it "should assign a winner" do
      auction.should_receive(:assign_winner).with(bidder)
      make_bid
    end
  end

  context "error handling" do
    it "returns errors when cannot make a bid" do
      auction.should_receive(:assign_winner).with(bidder).and_raise(InvalidRecordException.new([:error]))
      make_bid.should == {errors:  [:error]}
     end
  end

  private

  def make_bid
    Bidding.new(bidder, auction).make_bid
  end
end
