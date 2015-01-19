require "spec_helper"

describe PlanPresenter do
  let(:name) { "foo" }
  let(:period) { FactoryGirl.create(:period, name: name) }
  let(:plan) { FactoryGirl.create(:plan_with_assignments, period: period) }
  subject { described_class.new(plan) }

  describe "#name" do
    it "returns the name of the period" do
      expect(subject.name).to eq name
    end
  end
end
