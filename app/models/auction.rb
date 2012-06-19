class Auction < ActiveRecord::Base
  attr_accessible :seller, :item, :buy_it_now_price, :status

  belongs_to :item
  belongs_to :buyer, :class_name => 'User'
  belongs_to :seller, :class_name => 'User'

  PENDING = 'pending'
  STARTED = 'started'
  CLOSED = 'closed'
  CANCELED = 'canceled'

  validates :item, presence: true
  validates :seller, presence: true
  validates :status, inclusion: {in: [PENDING, STARTED, CLOSED, CANCELED]}

  def start
    self.status = STARTED
    save!
  end

  def self.make seller, item, buy_it_now_price
    create! seller: seller, item: item, buy_it_now_price: buy_it_now_price, status: PENDING
  end
end
