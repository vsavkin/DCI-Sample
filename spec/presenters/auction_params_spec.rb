require 'model_spec_helper'

describe AuctionParams do

  let(:params_with_string_date) do
    {"end_date(1i)" => 2001, "end_date(2i)" => 11, "end_date(3i)" => 10,
     "end_date(4i)" => 9, "end_date(5i)" => 8}
  end

  it "builds end date from array of strings" do
    params = AuctionParams.new(params_with_string_date)
    params.end_date.should == DateTime.new(2001,11,10,9,8)
  end

  it "uses real date when provided" do
    date = DateTime.new(2099,11,10,9,8)
    params = AuctionParams.new(end_date: date)
    params.end_date.should == date
  end

  it "prefers real date" do
    another_date = DateTime.new(2099,11,10,9,8)
    params = AuctionParams.new(params_with_string_date.merge(end_date: another_date))
    params.end_date.should == another_date
  end
end
