require 'model_spec_helper'

describe Item do
  context "make" do
    it "should create an item" do
      item = Item.make 'Name', 'Description'
      item.reload

      item.name.should == 'Name'
      item.description.should == 'Description'
    end

    it "should raise an exception when errors" do
      ->{Item.make nil, nil}.should raise_exception
    end
  end
end
