require 'model_spec_helper'

describe Auction do
  let(:seller){ObjectMother.create_user}

  let(:end_date){DateTime.current + 1.day}

  let(:item) {Item.create name: "Item"}

  let(:creation_attrs) do
    {seller: seller, item: item, buy_it_now_price: 10, extendable: true, end_date: end_date}
  end

  let(:auction){Auction.make creation_attrs}

  describe "Making a new auction" do
    example do
      auction = Auction.make creation_attrs
      auction.reload

      auction.seller.should == seller
      auction.item.should == item
      auction.buy_it_now_price.should == 10
      auction.extendable.should be_true
      auction.end_date.should == end_date
    end

    it "should set status to pending" do
      auction = Auction.make creation_attrs
      auction.status.should == Auction::PENDING
    end

    it "should raise an exception when errors" do
      ->{Auction.make({})}.should raise_exception(InvalidRecordException)
    end
  end

  describe "Making a bid" do
    let(:bidder){ObjectMother.create_user(email: "bidder@example.com")}

    example do
      bid = auction.make_bid bidder, 5
      bid.amount.should == 5
      auction.reload.bids.should == [bid]
    end

    it "raises an exception when errors" do
      ->{auction.make_bid nil, nil}.should raise_exception(InvalidRecordException)
    end
  end

  describe "Starting an auction" do
    example do
      auction.start
      auction.reload.status.should == Auction::STARTED
    end
  end

  describe "Extending an auction" do
    example do
      auction.extend_end_date_for 1.minute
      auction.reload.end_date.should == end_date + 1.minute
    end
  end

  describe "Assigning a winner" do
    let(:winner){ObjectMother.create_user(email: 'winner@example.com')}

    it "sets the winner" do
      auction.assign_winner winner
      auction.winner.should == winner
    end

    it "closes an auction" do
      auction.assign_winner winner
      auction.status.should == Auction::CLOSED
    end

    it "raises an exception when the seller is assigned as the winner" do
      ->{auction.assign_winner seller}.should raise_exception(InvalidRecordException)
    end
  end
end
