class ClosingExpiredAuctionsWorker
  include Sidekiq::Worker

  def perform
    Auction.find_in_batches do |auctions|
      ClosingExpiredAuctions.close auctions
    end
  end
end
