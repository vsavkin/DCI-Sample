require 'spec_helper'

feature "Buying an Item", js: true do
  let(:seller){
    User.create!(name: "Sam the Seller")
  }

  let(:item){
    Item.create!(name: "Item 1")
  }

  let(:auction){
    Auction.create!(item: item, seller: seller, buy_it_now_price: 10, status: Auction::STARTED)
  }

  scenario "Setting the buyer" do
    User.create!(name: "Bob")

    visit auction_path(auction)

    click_link "Buy It Now!"

    find("#winner").text.should == "Bob"
  end
end