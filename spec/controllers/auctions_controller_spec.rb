require 'spec_helper'

describe AuctionsController do
  describe "post 'CREATE'" do
    let(:current_user){stub}

    let(:auction_params){
      AuctionParams.new(item_name: 'name')
    }

    let(:request_params){
      {auction_params: {item_name: 'name'}}
    }

    before :each do
      controller.should_receive(:current_user).and_return(current_user)
    end

    context "successful" do
      let(:auction){stub(id: 1)}

      before :each do
        CreatingAuction.should_receive(:create).with(current_user, auction_params).and_return({auction: auction})
      end

      it "should render path to created auction" do
        xhr :post, :create, request_params
        response.body.should == {auction_path: auction_path(auction.id)}.to_json
      end

      it "should notify about success" do
        xhr :post, :create, request_params
        flash[:notice].should match("successfully")
      end
    end

    context "failed" do
      let(:errors){["error1"]}

      it "should render errors" do
        CreatingAuction.should_receive(:create).and_return({errors: errors})
        xhr :post, :create, request_params
        response.body.should == {errors: errors}.to_json
      end
    end
  end

  describe "get 'INDEX'" do
    before :each do
      Auction.should_receive(:all).and_return([Auction.new])
    end

    it "should render the list of all auctions wrapped into a presenter" do
      get :index

      assigns(:auctions).class == AuctionsPresenter
      assigns(:auctions).count == 1
    end
  end

  describe "get 'SHOW'" do
    let(:auction_id){1}
    let(:auction){Auction.new}

    before :each do
      Auction.should_receive(:find).with(auction_id.to_s).and_return(auction)
    end

    it "should render an auction wrapped into a presenter" do
      get :show, id: auction_id

      assigns(:auction).class == AuctionPresenter
      assigns(:auction).id == auction_id
    end
  end
end
