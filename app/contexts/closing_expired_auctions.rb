class ClosingExpiredAuctions
  include Context

  attr_reader :auctions

  def self.close auctions
    ClosingExpiredAuctions.new(auctions).close
  end

  def initialize auctions
    @auctions = auctions
  end

  def close
    in_context do
      auctions.each do |auction|
        auction.closes_when_expired
      end
    end
  end
end
