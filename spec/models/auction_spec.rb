require 'model_spec_helper'

describe Auction do
  let(:user){User.create! name: 'John'}
  let(:item){Item.create! name: 'Item'}

  context "make" do
    it "should create an auction" do
      auction = Auction.make user, item, 10
      auction.reload

      auction.seller.should == user
      auction.item.should == item
      auction.buy_it_now_price.should == 10
    end

    it "should set status to pending" do
      auction = Auction.make user, item, 10
      auction.status.should == Auction::PENDING
    end

    it "should raise an exception when errors" do
      ->{Auction.make nil, nil, 10}.should raise_exception(InvalidRecordException)
    end
  end

  context "start" do
    let(:auction){Auction.make user, item, 10}

    it "should set status to started" do
      auction.start
      auction.reload.status.should == Auction::STARTED
    end
  end
end
