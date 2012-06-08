require "unit_test_helper"

describe Test do
  it "returns bar" do
    Test.foo.should == "bar"
  end
end
