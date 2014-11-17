require 'spec_helper'

describe "book_bags/edit" do
  before(:each) do
    @book_bag = assign(:book_bag, stub_model(BookBag))
  end

  it "renders the edit book_bag form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", book_bag_path(@book_bag), "post" do
    end
  end
end
