require 'spec_helper'

describe Plan do
  subject { FactoryGirl.create(:plan_with_assignments) }

  describe "#assignments" do
    before do
      FactoryGirl.create(:assignment, plan: subject)
    end

    it "returns a list of assignments" do
      expect(subject.assignments).to be_all{|a| a.is_a?(Assignment)}
    end
  end

  describe "#ordered_book_bags" do
    it "returns a list of alpha-sorted book bags" do
      b1 = subject.assignments.first.book_bag
      b2 = subject.assignments.last.book_bag

      b1.update_attributes global_id: "10"
      b2.update_attributes global_id: "1"

      expect(subject.ordered_book_bags).to eq [b2, b1]
    end
  end

  describe "#active?" do
    it "is active if an inventory state has not been created" do
      expect(subject).to be_active
    end

    it "is false if an inventory state has been recorded" do
      FactoryGirl.create :inventory_state, period: subject.period
      expect(subject).to_not be_active
    end
  end

  describe "period creation after create runs" do
    it "creates a period" do
      expect(subject.period).to be_kind_of Period
    end
  end
end
