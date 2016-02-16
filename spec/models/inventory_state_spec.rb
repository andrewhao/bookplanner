require "spec_helper"

describe InventoryState do
  let(:period) { FactoryGirl.create :period }
  let(:plan) { FactoryGirl.create :plan_with_assignments, period: period }
  let(:classroom) { plan.classroom }
  let(:assignments) { plan.assignments }
  subject { FactoryGirl.create :inventory_state, period: period }

  before do
    plan
  end

  describe '#deletable?' do
    it 'is true when there exists a closed, most recent plan' do
      expect(subject).to be_deletable
    end

    it 'is false when there is an active plan' do
      new_period = create :period, classroom: classroom
      create :plan_with_assignments, period: new_period
      expect(subject).not_to be_deletable
    end
  end

  describe "#plan" do
    it "returns a Plan" do
      expect(subject.plan).to eq plan
    end
  end

  describe "#assignments" do
    it "returns several assignments persisted to the db" do
      assignments = FactoryGirl.create_list :assignment, 2
      subject.assignments += assignments
      expect(subject.reload.assignments).to eq assignments
    end
  end

  describe "#sorted_assignments" do
    it "displays in alpha descending ascending order by global id" do
      assns = FactoryGirl.create_list(:assignment, 2)
      assns.first.book_bag.update_attributes global_id: "10"
      assns.last.book_bag.update_attributes global_id: "2"
      subject.assignments = assns
      # expect 1, 10
      expect(subject.sorted_assignments).to eq assns.reverse
    end

    it "attaches assignments that are still out on loan at the end" do

    end
  end

  describe ".new_from_plan" do
    let(:subject) { described_class.new_from_plan(plan) }

    it "copies over the assignments from the classroom" do
      expect(subject.assignments).to match_array(classroom.assignments)
    end

    it "copies over all the classroom assignments, even those out on loan" do
      another_plan = FactoryGirl.create :plan_with_assignments, classroom: classroom
      other_assignments = another_plan.assignments
      expect(subject.assignments).to match_array(assignments + other_assignments)
    end

    it "copies over the period" do
      expect(subject.period).to eq plan.period
    end

    it "does not save the object" do
      expect(subject).to_not be_persisted
    end
  end
end
