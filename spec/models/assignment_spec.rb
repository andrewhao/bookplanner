require 'spec_helper'

describe Assignment do
  subject { FactoryGirl.create(:assignment) }

  it "creates" do
    expect(subject).to be_a Assignment
  end
end
