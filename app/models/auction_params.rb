class AuctionParams
  include FormFriendly
  include Virtus

  attribute :item_name, String
  attribute :item_description, String
  attribute :buy_it_now_price, Decimal
  attribute :end_date, DateTime

  def initialize params = nil
    if params
      end_date = DateTime.new(params["end_date(1i)"].to_i, params["end_date(2i)"].to_i, params["end_date(3i)"].to_i, params["end_date(4i)"].to_i, params["end_date(5i)"].to_i)
      super params.merge({"end_date" => end_date})
    else
      super
    end
  end

  def self.empty
    AuctionParams.new
  end

  def == other
    attributes == other.attributes
  end
end
