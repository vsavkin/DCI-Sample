class CreatingAuction
  include Context

  attr_reader :seller, :auction_creator, :listener

  def self.create user, auction_params, listener
    c = CreatingAuction.new user, auction_params, listener
    c.create
  end

  def initialize user, auction_params, listener
    @listener = listener
    @seller = user.extend Seller
    @auction_creator = auction_params.extend AuctionCreator
  end

  def create
    in_context do
      auction = seller.start_auction
      listener.create_on_success auction.id
    end
  rescue InvalidRecordException => e
    listener.create_on_error e.errors
  end

  module Seller
    include ContextAccessor

    def start_auction
      auction = context.auction_creator.create_auction self
      auction.start
      auction
    end
  end

  module AuctionCreator
    include ContextAccessor

    def create_auction seller
      item = create_item
      Auction.make creation_attributes(item, seller)
    end

    def creation_attributes item, seller
      basic_attrs = attributes.slice(:buy_it_now_price, :extendable, :end_date)
      basic_attrs.merge(item: item, seller: seller)
    end

    def create_item
      Item.make(item_name, item_description)
    end
  end
end
