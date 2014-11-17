require 'spec_helper'

describe "book_bags/index" do
  before(:each) do
    assign(:book_bags, [
      stub_model(BookBag),
      stub_model(BookBag)
    ])
  end

  it "renders a list of book_bags" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
