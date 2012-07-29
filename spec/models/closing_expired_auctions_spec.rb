require 'model_spec_helper'

describe ClosingExpiredAuctions do
  context "expired auction" do
    let(:bidder){stub}
    let(:bid){stub(user: bidder)}

    it "closes an auction if its end date is in the past and it's started" do
      auction = expired_auction last_bid: nil
      auction.should_receive(:close)
      ClosingExpiredAuctions.close [auction]
    end

    it "assigns a winner when auction has a bid" do
      auction = expired_auction last_bid: bid
      auction.should_receive(:assign_winner).with(bidder)
      ClosingExpiredAuctions.close [auction]
    end
  end

  context "not expired auction" do
    it "doesn't close an auction if its end date is in the future" do
      auction = stub(end_date: DateTime.current + 1.day, status: Auction::STARTED)
      ClosingExpiredAuctions.close [auction]
    end

    it "doesn't close an auction if it's not started" do
      auction = stub(end_date: DateTime.current - 1.day, status: Auction::PENDING)
      ClosingExpiredAuctions.close [auction]
    end
  end

  private
  def expired_auction attrs = {}
    mock({end_date: DateTime.current - 1.day, status: Auction::STARTED}.merge(attrs))
  end
end
