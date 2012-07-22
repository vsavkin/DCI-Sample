class ClosingExpiredAuctions
  include Context

  attr_reader :auctions

  def self.expire auctions
    ClosingExpiredAuctions.new(auctions).expire
  end

  def initialize auctions
    @auctions = auctions
  end

  def expire
    in_context do
      auctions.each do |auction|
        auction.closes_when_expired
      end
    end
  end
end
