require 'model_spec_helper'

describe AuctionParams do

  let(:params_with_string_date) do
    {"end_date(1i)" => 2001, "end_date(2i)" => 11, "end_date(3i)" => 10,
     "end_date(4i)" => 9, "end_date(5i)" => 8}
  end

  it "should build end date from array of strings" do
    params = AuctionParams.new(params_with_string_date)
    params.end_date.should == DateTime.new(2001,11,10,9,8)
  end

  it "should not set date end when no input" do
    params = AuctionParams.new({})
    params.end_date.should be_nil
  end
end
