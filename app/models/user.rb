require 'devise'
class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  composed_of :address, mapping: [%w(address_country country), %w(address_city city),
                                  %w(address_street street), %w(address_postal_code postal_code)],
                        converter: proc{|a| Address.new(a[:country], a[:city], a[:street], a[:postal_code])}
end
