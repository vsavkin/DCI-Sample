require 'unit_spec_helper'
require 'sidekiq'
require 'active_record'

describe ClosingExpiredAuctionsWorker do
  subject { described_class.new }
  let(:auctions){ [double('Auction')] }

  it "#perform" do
    Auction.should_receive(:find_in_batches).and_yield auctions
    ClosingExpiredAuctions.should_receive(:close).with auctions
    subject.perform
  end
end
