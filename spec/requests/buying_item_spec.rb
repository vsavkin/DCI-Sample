require 'spec_helper'

feature "Buying an Item", js: true do
  let!(:seller){
    User.create!(name: "Sam the Seller", email: "mail@email.com", password: "123456")
  }

  let!(:item){
    Item.create!(name: "Item 1")
  }

  let!(:auction){
    Auction.create!(item: item, seller: seller, buy_it_now_price: 10, status: Auction::STARTED)
  }

  scenario "Setting the buyer" do
    user = User.create!(name: "Bob", email: "mail1@email.com", password: "123456")
    do_login! user
    visit auction_path(auction)
    click_link "Buy It Now!"
    find("#winner").text.should == "Bob"
  end

  scenario "Trying to buy own item" do
    do_login! seller
    visit auction_path(auction)
    click_link "Buy It Now!"
    page.should have_content("Winner can't be equal to seller")
  end
end
