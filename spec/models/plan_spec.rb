require 'spec_helper'

describe Plan do
  subject { FactoryGirl.create(:plan) }

  describe "#assignments" do
    before do
      FactoryGirl.create(:assignment, plan: subject)
    end

    it "returns a list of assignments" do
      expect(subject.assignments).to be_all{|a| a.is_a?(Assignment)}
    end
  end

  describe "#active?" do
    it "is active if an inventory state has been created" do
      FactoryGirl.create :inventory_state, plan: subject
      expect(subject).to be_active
    end

    it "is false if an inventory state has not been recorded" do
      expect(subject).to_not be_active
    end
  end
end
