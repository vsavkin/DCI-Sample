require 'spec_helper'

feature "Creating Auction" do
  background do
    User.create(name: "Sam the Seller")
  end

  scenario "Successfully creating an auction" do
    visit new_auction_path

    fill_in "Item name", with: "Stamps"
    fill_in "Item description", with: "Collection of stamps"
    fill_in "Price", with: "200"
    click_button "Create"

    page.should have_content("Successfully created auction.")
  end
end