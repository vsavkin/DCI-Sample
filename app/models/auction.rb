class Auction < ActiveRecord::Base
  attr_accessible :seller, :item, :buy_it_now_price, :status

  belongs_to :item
  belongs_to :winner, :class_name => 'User'
  belongs_to :seller, :class_name => 'User'

  PENDING = 'pending'
  STARTED = 'started'
  CLOSED = 'closed'
  CANCELED = 'canceled'

  validates :item, presence: true
  validates :seller, presence: true
  validates :status, inclusion: {in: [PENDING, STARTED, CLOSED, CANCELED]}
  validates :buy_it_now_price, :numericality => true
  validate :buyer_and_seller

  def buyer_and_seller
    errors.add(:base, "can't be equal to seller") if seller_id == winner_id
  end

  def start
    self.status = STARTED
    save!
  end

  def close
    self.status = CLOSED
    save!
  end

  def started?
    status == STARTED
  end

  def assign_winner bidder
    self.winner = bidder
    close
  rescue ActiveRecord::RecordInvalid => e
    raise InvalidRecordException.new(e.record.errors.full_messages)
  end

  def self.make seller, item, buy_it_now_price
    create! seller: seller, item: item, buy_it_now_price: buy_it_now_price, status: PENDING
  rescue ActiveRecord::RecordInvalid => e
    raise InvalidRecordException.new(e.record.errors.full_messages)
  end
end
