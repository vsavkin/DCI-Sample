require 'spec_helper'

feature "Buying an Item", js: true do
  let(:end_date) { Time.zone.now + 1.day}

  let!(:seller){ObjectMother.create_user}

  let!(:item){Item.create!(name: "Item 1")}

  let!(:auction){make_auction end_date}

  let(:bidder){ObjectMother.create_user name: "Bob"}

  before :each do
    do_login! bidder
  end

  scenario "Setting the buyer" do
    visit auction_path(auction)
    click_link "Buy It Now!"

    find("#winner").text.should == "Bob"
  end

  scenario "Making a bid" do
    visit auction_path(auction)
    fill_in "bid_params_amount", with: "5"

    click_button "Bid"

    page.should have_content("Your bid is accepted")
  end

  scenario "Making an invalid bid" do
    visit auction_path(auction)
    fill_in "bid_params_amount", with: "INVALID"

    click_button "Bid"

    page.should have_content("is not a number")
  end

  scenario "Making a bid that extends an auction for extra 30 minutes" do
    end_date = Time.zone.now + 29.minutes
    auction = make_auction end_date
    visit auction_path(auction)

    fill_in "bid_params_amount", with: "5"

    click_button "Bid"
    page.should have_content("Your bid is accepted")

    auction.reload.end_date.should == end_date + 30.minutes
  end

  private

  def make_auction end_date
    ObjectMother.create_auction item: item, seller: seller, end_date: end_date
  end
end
