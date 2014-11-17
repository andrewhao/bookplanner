require 'spec_helper'

describe "book_bags/show" do
  before(:each) do
    @book_bag = assign(:book_bag, stub_model(BookBag))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
