class Item < ActiveRecord::Base
  attr_accessible :name, :description

  validates :name, presence: true

  def self.make name, description
    Item.create!(name: name, description: description)
  rescue ActiveRecord::RecordInvalid => e
    raise InvalidRecordException.new(e.record.errors.full_messages)
  end
end
