require "spec_helper"

describe InventoryState do
  let(:period) { FactoryGirl.create :period }
  let(:plan) { FactoryGirl.create :plan_with_assignments, period: period }
  subject { FactoryGirl.create :inventory_state, period: period }

  before do
    plan
  end

  describe "#plan" do
    it "returns a Plan" do
      expect(subject.plan).to eq plan
    end
  end

  describe "#assignments" do
    it "returns several book bags" do
      assignments = FactoryGirl.create_list :assignment, 2
      subject.assignments += assignments
      expect(subject.reload.assignments).to eq assignments
    end
  end

  describe ".new_from_plan" do
    let(:subject) { described_class.new_from_plan(plan) }

    it "copies over the assignments from a plan" do
      expect(subject.assignments).to match_array(plan.assignments)
    end

    it "copies over the period" do
      expect(subject.period).to eq plan.period
    end

    it "does not save the object" do
      expect(subject).to_not be_persisted
    end
  end
end
