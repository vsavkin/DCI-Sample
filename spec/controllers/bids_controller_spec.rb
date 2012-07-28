require 'spec_helper'

describe BidsController do
  let(:current_user){stub}
  let(:auction_id){"999"}

  before :each do
    controller.should_receive(:current_user).and_return(current_user)
  end

  describe "post 'CREATE'" do
    let(:amount){"999"}

    let(:request_params){
      {auction_id: auction_id, bid_params: {amount: amount}}
    }

    let(:bid_params){
      BidParams.new(auction_id: auction_id, amount: amount)
    }

    context "successful" do
      it "should render path to created auction" do
        Bidding.should_receive(:bid).with(current_user, bid_params).and_return({})

        post :create, request_params
        response.should redirect_to(auction_path auction_id)
      end
    end

    context "failed" do
      let(:errors){["error1"]}

      it "should render errors" do
        Bidding.should_receive(:bid).and_return({errors: errors})

        post :create, request_params
        response.should redirect_to(auction_path auction_id)
        flash[:error].should be_present
      end
    end
  end

  describe "post 'BUY IT NOW'" do
    let(:request_params){
      {auction_id: auction_id}
    }

    let(:bid_params){
      BidParams.new(auction_id: auction_id)
    }

    context "successful" do
      it "should render path to created auction" do
        Bidding.should_receive(:buy).with(current_user, bid_params).and_return({})

        post :buy, request_params
        response.should redirect_to(auction_path auction_id)
      end
    end

    context "failed" do
      let(:errors){["error1"]}

      it "should render errors" do
        Bidding.should_receive(:buy).and_return({errors: errors})

        post :buy, request_params
        response.should redirect_to(auction_path auction_id)
        flash[:error].should be_present
      end
    end
  end
end
