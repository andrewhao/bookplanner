require "spec_helper"

describe PlanPresenter do
  let(:name) { "foo" }
  let(:plan) { FactoryGirl.create(:plan_with_assignments, name: name) }
  subject { described_class.new(plan) }

  describe "#title" do
    it "returns the title of the period" do
      expect(subject.name).to eq name
    end
  end
end
