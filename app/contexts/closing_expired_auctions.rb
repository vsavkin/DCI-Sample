class ClosingExpiredAuctions
  include Context

  attr_reader :auctions

  def self.close auctions
    ClosingExpiredAuctions.new(auctions).close
  end

  def initialize auctions
    auctions.map{|auction| auction.extend Expirable}
    @auctions = auctions
  end

  def close
    in_context do
      auctions.each do |auction|
        auction.closes_when_expired
      end
    end
  end

  module Expirable
    def expired?
      end_date < DateTime.current
    end

    def closes_when_expired
      update_attribute(:status, CLOSED) if expired?
    end
  end
end
