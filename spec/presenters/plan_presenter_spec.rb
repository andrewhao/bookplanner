require "spec_helper"

describe PlanPresenter do
  let(:name) { "foo" }
  let(:period) { FactoryGirl.create(:period, name: name) }
  let(:plan) { FactoryGirl.create(:plan_with_assignments, period: period) }
  let(:assignments) { plan.assignments }
  subject { described_class.new(plan) }

  describe "#name" do
    it "returns the name of the period" do
      expect(subject.name).to eq name
    end
  end

  describe "#display_cell_for" do
    let(:assignment) { assignments.first }

    context "for student in plan" do
      it "returns global id" do
        expect(subject.display_cell_for(assignment.student)).to eq assignment.book_bag.global_id
      end
    end

    context "for nonexistent student" do
      it "returns emdash" do
        student = FactoryGirl.create :student
        expect(subject.display_cell_for(student)).to eq "<span class='text-muted'>&mdash;</span>"
      end
    end
  end
end
