require 'spec_helper'

feature "Viewing Auctions", js: true do
  background do
    seller = User.create(name: "Sam the Seller", email: "mail@email.com", password: "123456")

    item1 = Item.create!(name: "Item 1")
    Auction.create!(item: item1, seller: seller, buy_it_now_price: 10, status: Auction::STARTED)

    item2 = Item.create!(name: "Item 2")
    Auction.create!(item: item2, seller: seller, buy_it_now_price: 10, status: Auction::STARTED)
  end

  scenario "Viewing all auctions" do
    visit auctions_path

    page.should have_content("Item 1")
    page.should have_content("Item 2")
  end

  scenario "Going from the list of auctions to an individual auction" do
    visit auctions_path

    click_link "Item 1"

    find(:xpath, '//title').text.should match("Item 1")
  end
end
