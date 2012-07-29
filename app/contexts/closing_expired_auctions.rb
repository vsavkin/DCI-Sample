class ClosingExpiredAuctions
  include Context

  def self.close auctions
    ClosingExpiredAuctions.new(auctions).close
  end

  attr_reader :expirable_auctions

  def initialize auctions
    @expirable_auctions = auctions.map{|auction| auction.extend Expirable}
  end

  def close
    in_context do
      expirable_auctions.each do |auction|
        auction.close_if_expired
      end
    end
  end

  module Expirable
    def close_if_expired
      return unless expired?

      if winning_bid?
        close_with_winner
      else
        close_without_winner
      end
    end

    def close_with_winner
      assign_winner last_bid.user
    end

    def close_without_winner
      close
    end

    def winning_bid?
      last_bid.present?
    end

    def expired?
      end_date < DateTime.current and status == Auction::STARTED
    end
  end
end
