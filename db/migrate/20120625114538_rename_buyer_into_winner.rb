class RenameBuyerIntoWinner < ActiveRecord::Migration
  def change
    rename_column :auctions, :buyer_id, :winner_id
  end
end
