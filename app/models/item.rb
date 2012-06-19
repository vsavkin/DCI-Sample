class Item < ActiveRecord::Base
  attr_accessible :name, :description

  validates :name, presence: true

  def self.make name, description
    Item.create!(name: name, description: description)
  end
end
