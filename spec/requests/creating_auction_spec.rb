require 'spec_helper'

feature "Creating an Auction", js: true do
  let!(:user){ObjectMother.create_user}

  background do
    do_login! user
  end

  scenario "Successfully creating an auction" do
    visit new_auction_path

    fill_in "Name", with: "Stamps"
    fill_in "Description", with: "Collection of stamps"
    fill_in "Buy it now price", with: "200"
    fill_in "End date", with: "2020-01-01 00:00:00"
    click_button "Create"

    page.should have_content("Auction was successfully created.")
  end

  scenario "Showing errors when cannot create an auction" do
    visit new_auction_path

    fill_in "Name", with: ""
    fill_in "Description", with: "Collection of stamps"
    fill_in "Buy it now price", with: "200"
    fill_in "End date", with: "2020-01-01 00:00:00"
    click_button "Create"

    page.should have_content("Name can't be blank")
  end
end
