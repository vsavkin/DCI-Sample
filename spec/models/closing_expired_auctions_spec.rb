require 'model_spec_helper'

describe ClosingExpiredAuctions do
  let(:auction) { mock('Auction') }

  it "expires auctions closing each one" do
    auction.should_receive(:closes_when_expired)
    described_class.expire [auction]
  end
end
