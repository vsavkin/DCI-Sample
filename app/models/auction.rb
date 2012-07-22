class Auction < ActiveRecord::Base
  attr_accessible :seller, :item, :buy_it_now_price, :status, :end_date

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
  validates :end_date, presence: true
  validate :end_date_period

  def closes_when_expired
    update_attribute(:status, CLOSED) if expired?
  end

  def expired?
    end_date < DateTime.current
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

  def closed?
    status == CLOSED
  end

  def assign_winner bidder
    self.winner = bidder
    close
  rescue ActiveRecord::RecordInvalid => e
    raise InvalidRecordException.new(e.record.errors.full_messages)
  end

  def self.make seller, item, buy_it_now_price, end_date
    create! seller: seller, item: item, buy_it_now_price: buy_it_now_price, end_date: end_date, status: PENDING
  rescue ActiveRecord::RecordInvalid => e
    raise InvalidRecordException.new(e.record.errors.full_messages)
  end

  private

  def end_date_period
    errors.add(:end_date, "must be in the future") if end_date < DateTime.current
  end

  def buyer_and_seller
    errors.add(:base, "can't be equal to seller") if seller_id == winner_id
  end
end
