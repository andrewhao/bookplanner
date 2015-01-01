require "spec_helper"

describe PlanPresenter do
  let(:plan) { FactoryGirl.build(:plan) }
  let(:c) { plan.classroom }
  subject { described_class.new(plan) }
  let(:s1) { FactoryGirl.create(:student, classroom: c, first_name: "a") }
  let(:s2) { FactoryGirl.create(:student, classroom: c, first_name: "m") }
  let(:s3) { FactoryGirl.create(:student, classroom: c, first_name: "z") }

  describe "#assignments" do
    it "returns assignments in alpha order by student" do
      a1 = FactoryGirl.build(:assignment, plan: plan, student: s2)
      a2 = FactoryGirl.build(:assignment, plan: plan, student: s3)
      a3 = FactoryGirl.build(:assignment, plan: plan, student: s1)
      plan.assignments = [a1, a2, a3]
      plan.save
      expect(subject.assignments.map(&:student)).to eq [s1, s2, s3]
    end
  end
end
