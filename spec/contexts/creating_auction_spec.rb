require 'model_spec_helper'

describe CreatingAuction do
  let(:seller){User.new}

  let(:end_date){DateTime.new(2013, 8, 26, 15, 24)}

  let(:auction_params) {
    {item_name: "Item", item_description: "Description", buy_it_now_price: 10,
     extendable: true, end_date: end_date}
  }

  let(:params){
    AuctionParams.new(auction_params)
  }

  let(:listener){stub.as_null_object}

  describe "Successful creation" do
    let(:expected_item){double("Item")}
    let(:expected_auction){double("Auction", id: 9999).as_null_object}

    before do
      Item.stub(:make){expected_item}
      Auction.stub(:make){expected_auction}
    end

    it "creates an auction" do
      Item.should_receive(:make).with("Item", "Description").and_return(expected_item)

      expected_attrs = {buy_it_now_price: 10, extendable: true, end_date: end_date, seller: seller, item: expected_item}
      Auction.should_receive(:make).with(expected_attrs)

      create_auction
    end

    it "starts the created auction" do
      expected_auction.should_receive(:start)

      create_auction
    end

    it "notifies the listener about the created auction" do
      listener.should_receive(:create_on_success).with(expected_auction.id)

      create_auction
    end
  end

  describe "Error handling" do
    let(:errors){%w{error1}}

    it "notifies the listener when cannot create an item" do
      Item.stub(:make).and_raise(InvalidRecordException.new(errors))
      listener.should_receive(:create_on_error).with(errors)

      create_auction
    end

    it "notifies the listener when cannot create an auction" do
      Item.stub(:make)
      Auction.stub(:make).and_raise(InvalidRecordException.new(errors))
      listener.should_receive(:create_on_error).with(errors)

      create_auction
    end
  end

  private

  def create_auction
    CreatingAuction.new(seller, params, listener).create
  end
end
