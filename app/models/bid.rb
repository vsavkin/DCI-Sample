class Bid < ActiveRecord::Base
  attr_accessible :amount, :user

  belongs_to :user

  validates :user, presence: true
  validates :amount, :numericality => true
end
