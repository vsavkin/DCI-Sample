require 'devise'
class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  validates :name, presence: true
  validates :email, presence: true

  def address
    Address.new(address_country, address_city, address_street, address_postal_code)
  end

  def address= address
    self[:address_country] = address.country
    self[:address_city] = address.city
    self[:address_street] = address.street
    self[:address_postal_code] = address.postal_code
  end
end


