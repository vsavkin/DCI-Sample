require 'spec_helper'

feature "Creating an Auction", js: true do
  let!(:user){User.create!(name: "Sam the Seller", email: "mail@email.com", password: "123456")}

  background do
    do_login! user
  end

  scenario "Successfully creating an auction" do
    visit new_auction_path
    fill_in "auction_params_item_name", with: "Stamps"
    fill_in "Item description", with: "Collection of stamps"
    fill_in "Buy it now price", with: "200"
    select "2017", from: "auction_params_end_date_1i"
    click_button "Create"

    page.should have_content("Auction was successfully created.")
  end

  scenario "Showing errors when cannot create an auction" do
    visit new_auction_path

    fill_in "auction_params_item_name", with: ""
    fill_in "Item description", with: "Collection of stamps"
    fill_in "Buy it now price", with: "200"
    click_button "Create"

    page.should have_content("Name can't be blank")
  end
end
