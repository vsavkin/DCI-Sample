require 'model_spec_helper'

describe Bidding do
  let(:auction){double("Auction")}
  let(:buyer){double("Buyer")}
  subject{ described_class.new buyer, auction }

  context "successful creation" do
    it "makes a bid" do
      described_class.should_receive(:new).with(buyer, auction).and_return(bidding = mock("bidding"))
      bidding.should_receive(:make_bid)
      described_class.make_bid buyer, auction
    end

    it "buys an item" do
      buyer.should_receive(:buy_item).and_return auction
      subject.make_bid.should == {auction:  auction}
    end

    it "closes the auction" do
      auction.should_receive(:close_auction)
      subject.make_bid
    end
  end

  context "error handling" do
    it "returns errors when cannot make a bid" do
      auction.should_receive(:assign_buyer).with(buyer).and_raise(InvalidRecordException.new([:error]))
      subject.make_bid.should == {errors:  [:error]}
     end
  end
end
