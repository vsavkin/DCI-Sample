class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.integer :auction_id
      t.integer :user_id
      t.decimal :amount
      t.timestamps
    end
  end
end
