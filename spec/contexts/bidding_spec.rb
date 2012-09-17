require 'model_spec_helper'

describe Bidding do
  let(:listener){stub.as_null_object}

  let(:bidder){User.new}

  let(:auction){double("Auction", buy_it_now_price: 999999, started?: true, end_date: Time.now + 1.day)}

  before :each do
    auction.stub(:assign_winner)
    auction.stub(:extend_end_date_for)
    auction.stub(:make_bid){bid}
    auction.stub(:last_bid){nil}
  end

  describe "Bidding" do
    let(:amount){777}

    example do
      bid = bid(bidder: bidder, amount: amount)

      auction.should_receive(:make_bid).with(bidder, amount).and_return(bid)

      make_bid amount: amount
    end

    it "notifies the listener about the created bid" do
      listener.should_receive(:create_on_success).with("Your bid is accepted.")

      make_bid
    end
  end

  describe "Validations" do
    let(:another_bidder){User.new}

    it "errors when no amount" do
      listener.should_receive(:create_on_error)

      make_bid amount: nil
    end

    it "errors when an invalid amount" do
      listener.should_receive(:create_on_error)

      make_bid amount: "INVALID"
    end

    it "errors when the bidder is bidding against himself" do
      amount = 777
      auction.stub(:last_bid).and_return(bid(bidder: bidder, amount: amount - 1))

      listener.should_receive(:create_on_error)

      make_bid amount: amount
    end

    it "errors when the amount of the last bid is the same" do
      auction.stub(:last_bid).and_return(bid(bidder: another_bidder, amount: 777))

      listener.should_receive(:create_on_error)

      make_bid amount: 777
    end

    it "errors when bidding on a closed auction" do
      auction.stub(started?: false)

      listener.should_receive(:create_on_error)

      make_bid
    end
  end

  describe "Extending the auction" do
    it "increases the auction's end date when the bid is made within the extending interval" do
      auction.stub(end_date: Time.now)

      auction.should_receive(:extend_end_date_for).with(Bidding::EXTENDING_INTERVAL)

      make_bid
    end

    it "does not extend when more time left" do
      auction.stub(end_date: Time.now + 31.minute)

      auction.should_not_receive(:extend_end_date_for)

      make_bid
    end

    it "does not extend when auction is not started" do
      auction.stub(end_date: Time.now, started?: false)

      auction.should_not_receive(:extend_end_date_for)

      make_bid
    end

    it "notifies the listener about the extension" do
      auction.stub(end_date: Time.now)

      listener.should_receive(:create_on_success).with("Your bid is accepted, and the auction has been extended for 30 minutes.")

      make_bid
    end
  end

  describe "Buying" do
    let(:buy_it_now_price) {777}

    before do
      auction.stub(buy_it_now_price: buy_it_now_price)
    end

    it "assigns the winner" do
      auction.stub(make_bid: bid(amount: buy_it_now_price))

      auction.should_receive(:assign_winner).with(bidder)

      make_bid amount: buy_it_now_price
    end

    it "notifies the listener when the bid greater than the buy it now price" do
      listener.should_receive(:create_on_error)

      make_bid amount: buy_it_now_price + 1
    end

    it "notifies the listener about the purchase" do
      auction.stub(make_bid: bid(amount: buy_it_now_price))

      listener.should_receive(:create_on_success).with("Purchased successfully performed.")

      make_bid amount: buy_it_now_price
    end
  end

  describe "Error handling" do
    it "notifies the listener when cannot make a bid" do
      auction.stub(:make_bid).and_raise(InvalidRecordException.new([:error]))

      listener.should_receive(:create_on_error).with([:error])

      make_bid
    end
  end

  private

  def make_bid options = {}
    amount = options.fetch(:amount, 999)
    params = BidParams.new(amount: amount, auction: auction)
    user = options.fetch(:bidder, bidder)
    Bidding.new(user, auction, params, listener).bid
  end

  def bid options = {}
    stub(user: options.fetch(:bidder, bidder), amount: options.fetch(:amount, 999))
  end
end
