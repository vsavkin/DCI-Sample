class AuctionParams
  include FormFriendly
  include Virtus

  attribute :item_name, String
  attribute :item_description, String
  attribute :buy_it_now_price, Decimal
  attribute :end_date, DateTime
  attribute :extendable, Boolean

  def initialize params
    super build_end_date(params)
  end

  def self.empty
    AuctionParams.new({})
  end

  def == other
    attributes == other.attributes
  end

  private

  def build_end_date params
    return unless has_end_date? params

    year = params["end_date(1i)"].to_i
    month = params["end_date(2i)"].to_i
    day = params["end_date(3i)"].to_i
    hour = params["end_date(4i)"].to_i
    minute = params["end_date(5i)"].to_i

    date = DateTime.new(year, month, day, hour, minute)
    params.merge(end_date: date)
  end

  def has_end_date? params
    params.has_key? "end_date(1i)"
  end
end
