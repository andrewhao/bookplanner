require 'spec_helper'

describe Assignment do
  subject { FactoryGirl.create(:assignment) }

  it "creates" do
    expect(subject).to be_a Assignment
  end

  describe "#on_loan?" do
    it "is true when no inventory state association" do
      is = FactoryGirl.create :inventory_state, assignments: [subject]

      expect(subject).to be_on_loan
    end

    it "is false when an inventory state is associated" do
      expect(subject).to_not be_on_loan
    end
  end
end
