require 'spec_helper'

describe Assignment do
  subject { FactoryGirl.create(:assignment_with_plan) }
  let(:plan) { subject.plan }

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

  describe "#loaned_period" do
    it "returns the period the assignment was loaned out from" do
      expect(subject.loaned_period).to eq plan.period
    end
  end

  describe "#returned_period" do
    it "returns nil if the assignment has not yet been returned" do
      expect(subject.returned_period).to be_nil
    end
  end

  describe "#display_info" do
    it "returns a string with student, bag ID and interval" do
      subject.student.update_attributes(first_name: "Edith", last_name: "Han")
      subject.book_bag.update_attributes(global_id: 1234)
      subject.loaned_period.update_attributes(name: "Week Three")
      expect(subject.display_info).to eq "Edith Han still has bag #1234 checked out since Week Three"
    end
  end
end
