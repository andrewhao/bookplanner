require 'spec_helper'

describe "book_bags/new" do
  before(:each) do
    assign(:book_bag, stub_model(BookBag).as_new_record)
  end

  it "renders new book_bag form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", book_bags_path, "post" do
    end
  end
end
