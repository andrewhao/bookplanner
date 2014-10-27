require 'spec_helper'

describe "classrooms/index" do
  before(:each) do
    assign(:classrooms, [
      stub_model(Classroom),
      stub_model(Classroom)
    ])
  end

  it "renders a list of classrooms" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
