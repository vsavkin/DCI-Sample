class User < ActiveRecord::Base
  attr_accessible :name

  composed_of :address, mapping: [%w(address_country country), %w(address_city city),
                                  %w(address_street street), %w(address_postal_code postal_code)],
                        converter: proc{|a| Address.new(a[:country], a[:city], a[:street], a[:postal_code])}
end
