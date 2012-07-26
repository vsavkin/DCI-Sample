require 'model_spec_helper'

describe ClosingExpiredAuctions do
  let(:auction) { mock('Auction', end_date: DateTime.current - 1.day) }

  it "expires auctions closing each one" do
    auction.should_receive(:close)
    described_class.close [auction]
  end
end
