require 'spec_helper'

feature "Viewing Auctions", js: true do
  let(:end_date) { DateTime.current + 1.day}

  background do
    seller = ObjectMother.create_user

    ObjectMother.create_auction item: Item.create!(name: "Item 1"), seller: seller
    ObjectMother.create_auction item: Item.create!(name: "Item 2"), seller: seller
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
