require 'spec_helper'

describe BidsController do
  describe "post 'CREATE'" do
    let(:current_user){stub}
    let(:auction_id){"999"}
    let(:request_params){
      {auction_id: auction_id}
    }

    before :each do
      controller.should_receive(:current_user).and_return(current_user)
    end

    context "successful" do
      it "should render path to created auction" do
        Bidding.should_receive(:make_bid).with(current_user, auction_id).and_return({})

        post :create, request_params
        response.should redirect_to(auction_path auction_id)
      end
    end

    context "failed" do
      let(:errors){["error1"]}

      it "should render errors" do
        Bidding.should_receive(:make_bid).and_return({errors: errors})

        post :create, request_params
        response.should redirect_to(auction_path auction_id)
        flash[:error].should be_present
      end
    end
  end
end
