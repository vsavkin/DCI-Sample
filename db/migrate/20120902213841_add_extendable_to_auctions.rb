class AddExtendableToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :extendable, :boolean, default: false
  end
end
