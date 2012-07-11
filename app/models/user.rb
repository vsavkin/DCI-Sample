class User < ActiveRecord::Base
  attr_accessible :name

  def address
    @address ||= Address.new(address_country, address_city, address_street, address_postal_code)
  end

  def address=(address)
    self[:address_country] = address.country
    self[:address_city] = address.city
    self[:address_street] = address.street
    self[:address_postal_code] = address.postal_code

    @address = address
  end
end


