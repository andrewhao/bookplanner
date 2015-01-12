require 'spec_helper'

describe Assignment do
  subject { FactoryGirl.create(:assignment) }

  it "creates" do
    expect(subject).to be_a Assignment
  end

  describe ".display_sorted" do
    it "displays in alpha descending ascending order by global id" do
      assns = FactoryGirl.create_list(:assignment, 2)
      assns.first.book_bag.update_attributes global_id: "10"
      assns.last.book_bag.update_attributes global_id: "1"

      expect(described_class.display_sorted).to eq assns.reverse
    end
  end

  describe "#on_loan?" do
    it "is true when no inventory state association" do
      expect(subject).to be_on_loan
    end

    it "is false when an inventory state is associated" do
      FactoryGirl.create :inventory_state, assignments: [subject]
      expect(subject).to_not be_on_loan
    end
  end
end
