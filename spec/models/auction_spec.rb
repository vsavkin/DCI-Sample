require 'model_spec_helper'

describe Auction do
  let(:seller){ObjectMother.create_user(email: "seller@example.com")}
  let(:item){Item.create name: "Item"}
  let(:end_date){DateTime.current + 1.day}
  let(:extendable) { true }

  context "making a new auction" do
    it "should create an auction" do
      auction = Auction.make seller, item, 10, extendable, end_date
      auction.reload

      auction.seller.should == seller
      auction.item.should == item
      auction.buy_it_now_price.should == 10
    end

    it "should set status to pending" do
      auction = Auction.make seller, item, 10, extendable, end_date
      auction.status.should == Auction::PENDING
    end

    it "should raise an exception when errors" do
      ->{Auction.make nil, nil, 10, extendable, end_date}.should raise_exception(InvalidRecordException)
    end
  end

  context "making a bid" do
    let(:auction){Auction.make seller, item, 10, extendable, end_date}
    let(:bidder){ObjectMother.create_user(email: "bidder@example.com")}

    it "should create a bid" do
      bid = auction.make_bid bidder, 5
      bid.amount.should == 5
      auction.reload.bids.should == [bid]
    end

    it "should raise an exception when errors" do
      ->{auction.make_bid nil, nil}.should raise_exception(InvalidRecordException)
    end
  end

  context "starting an auction" do
    let(:auction){Auction.make seller, item, 10, extendable, end_date}

    it "should set status to started" do
      auction.start
      auction.reload.status.should == Auction::STARTED
    end
  end

  context "assigning a winner" do
    let(:auction){Auction.make seller, item, 10, extendable, end_date }
    let(:winner){ObjectMother.create_user(email: "seller@winner.com") }

    it "should set the winner" do
      auction.assign_winner winner
      auction.winner.should == winner
    end

    it "should close an auction" do
      auction.assign_winner winner
      auction.status.should == Auction::CLOSED
    end

    it "should raise an exception when the seller is assigned as the winner" do
      ->{auction.assign_winner seller}.should raise_exception(InvalidRecordException)
    end
  end
end
