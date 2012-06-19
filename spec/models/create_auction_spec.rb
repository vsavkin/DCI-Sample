require 'model_spec_helper'

describe CreateAuction do
  let(:seller){User.new}

  let(:params) do
    AuctionParams.new(item_name: "Item", item_description: "Description", price: 10)
  end

  context "successful creation" do
    let(:expected_item){Item.new}
    let(:expected_auction){Auction.new}

    before :each do
      Item.should_receive(:make).with("Item", "Description").and_return(expected_item)
      Auction.should_receive(:make).with(seller, expected_item, 10).and_return(expected_auction)
    end

    it "should create an auction" do
      actual_auction = CreateAuction.new(seller, params).create
      actual_auction.should == expected_auction
    end

    it "should start the created auction" do
      actual_auction = CreateAuction.new(seller, params).create
      actual_auction.status == Auction::STARTED
    end
  end
end
