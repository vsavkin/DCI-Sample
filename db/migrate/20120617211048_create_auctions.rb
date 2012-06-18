class CreateAuctions < ActiveRecord::Migration
  def change
    create_table :auctions do |t|
      t.string :status
      t.decimal :buy_it_now_price
      t.references :item

      t.timestamps
    end
  end
end
