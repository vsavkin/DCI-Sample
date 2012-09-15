require 'model_spec_helper'

describe Item do
  it "creates an item" do
    item = Item.make 'Name', 'Description'
    item.reload

    item.name.should == 'Name'
    item.description.should == 'Description'
  end

  it "raises an exception when errors" do
    -> { Item.make nil, nil }.should raise_exception(InvalidRecordException)
  end
end
