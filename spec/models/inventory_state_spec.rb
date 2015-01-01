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
end
