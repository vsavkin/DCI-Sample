require 'model_spec_helper'

describe Bidding do
  let(:buy_it_now_price){10000}
  let(:auction){double("Auction", buy_it_now_price: buy_it_now_price, started?: true, end_date: 20.minutes.from_now)}
  let(:another_bidder){User.new}
  let(:bidder){User.new}

  before :each do
    auction.stub(:assign_winner)
    auction.stub(:extend_end_date_for)
    auction.stub(:make_bid)
    auction.stub(:last_bid){nil}
  end

  context "making a bid" do
    let(:amount) {999}

    example do
      expect_bid_creation bidder, amount
      make_bid(amount)
    end

    it "should associate the bid with the auction" do
      bid_creation bidder, amount
      make_bid(amount)
    end

    it "should return the created bid" do
      bid = bid_creation bidder, amount
      response = make_bid(amount)
      response[:bid].should == bid
    end

    it "should error when no amount" do
      response = make_bid(nil)
      response[:errors].should be_present
    end

    it "should error when invalid amount" do
      response = make_bid("INVALID")
      response[:errors].should be_present
    end

    it "should error when the bidder is bidding against himself" do
      auction.stub(:last_bid).and_return(bid(bidder, amount - 1))
      response = make_bid(amount)
      response[:errors].should be_present
    end

    it "should error when the bid is not smaller then the previous one + 1 dollar" do
      auction.stub(:last_bid).and_return(bid(another_bidder, amount))
      response = make_bid(amount)
      response[:errors].should be_present
    end

    it "should error when bidding on a closed auction" do
      auction.stub(:started?).and_return(false)
      response = make_bid(amount)
      response[:errors].should be_present
    end

    context "buying" do
      it "should assign winner" do
        bid_creation bidder, buy_it_now_price
        auction.should_receive(:assign_winner).with(bidder)
        make_bid buy_it_now_price
      end

      it "should error when the bid greater than the buy it now price" do
        response = make_bid(buy_it_now_price + 1)
        response[:errors].should be_present
      end
    end

    context "extending the auction" do
      it "should extend the auction when the bid is made within extending interval" do
        bid_creation bidder, amount
        auction.stub(end_date: Time.now)
        auction.should_receive(:extend_end_date_for).with(Bidding::EXTENDING_INTERVAL)
        make_bid amount
      end

      it "should not extend when more time left" do
        bid_creation bidder, amount
        auction.stub(end_date: Time.now + 31.minute)
        auction.should_not_receive(:extend_end_date_for)
        make_bid amount
      end

      it "should not extend when auction is not started" do
        bid_creation bidder, buy_it_now_price
        auction.stub(end_date: Time.now, started?: false)
        auction.should_not_receive(:extend_end_date_for)
        make_bid amount
      end
    end
  end

  context "error handling" do
    it "should return errors when cannot make a bid" do
      auction.should_receive(:make_bid).and_raise(InvalidRecordException.new([:error]))
      make_bid(999).should == {errors: [:error]}
    end
  end

  private

  def bid_creation bidder, amount
    bid = bid(bidder, amount)
    auction.stub(:make_bid).with(bidder, amount).and_return(bid)
    return bid
  end

  def expect_bid_creation bidder, amount
    bid = bid(bidder, amount)
    auction.should_receive(:make_bid).with(bidder, amount).and_return(bid)
    return bid
  end

  def bid user, amount
    stub(user: user, amount: amount)
  end

  def make_bid amount
    params = BidParams.new(amount: amount, auction: auction)
    Bidding.new(bidder, auction, params).bid
  end
end
