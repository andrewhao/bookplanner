require "spec_helper"

describe PlanRegenerator do
  # Set up the scenario where:
  #   - 2 students
  #   - Period 1:
  #     - Plan: {s1: b1, s2: b2}
  #     - Inventory: { s1: b1 }
  #   - Period 2:
  #     - Plan: {s1: b2}
  let(:book_bags) { create_list(:book_bag, 2) }
  let(:bag1) { book_bags.first }
  let(:bag2) { book_bags.second }
  let(:student1) { students.first }
  let(:student2) { students.last }

  let(:old_period) { create(:period, classroom: classroom, created_at: "1971-01-01") }
  let(:old_assignment1) { create(:assignment, book_bag: bag1, student: student1) }
  let(:old_assignment2) { create(:assignment, book_bag: bag2, student: student2) }
  let!(:old_plan) { create(:plan, assignments: [old_assignment1, old_assignment2], period: old_period) }
  let!(:old_inventory_state) { create(:inventory_state, period: old_period, assignments: [old_assignment1]) }

  let(:students) { create_list(:student, 2) }
  let(:classroom) { create(:classroom, book_bags: book_bags, students: students) }
  let!(:assignment) { create(:assignment, book_bag: bag2, student: student1) }
  let(:current_period) { create(:period, classroom: classroom) }
  let(:plan) { create(:plan, assignments: [assignment], period: current_period) }

  subject { described_class.new(plan) }

  it "deletes a plan" do
    subject.regenerate
    expect do
      plan.reload
    end.to raise_error ActiveRecord::RecordNotFound
  end

  it "deletes the plan assignments" do
    subject.regenerate

    expect do
      assignment.reload
    end.to raise_error ActiveRecord::RecordNotFound
  end

  it "creates a new plan" do
    new_plan = subject.regenerate
    new_plan.reload
    expect(new_plan.id).to be > plan.id
    expect(new_plan.period).to eq current_period
  end

  it "calls the PlanGenerator with a template" do
    generator = instance_double(PlanGenerator)
    template = { student1.id => bag2.id }
    expect(PlanGenerator).to receive(:new).
      with([student1],
           [bag1],
           template: template).
      and_return(generator)

    expect(generator).to receive(:generate).and_return([create(:assignment)])

    subject.regenerate
  end

  it "raises a PlanNotFound exception if the Regenerator fails" do
    subject.regenerate
  end

  describe '#delta' do
    it "returns an empty string when nothing changes" do
      subject.regenerate
      expect(subject.delta).to eq ""
    end

    it "returns a change message when things change" do
      subject.regenerate do |_old_plan|
        old_inventory_state.return! old_assignment2
      end

      expect(subject.delta).to include "newly assigned Book Bag"
    end
  end
end
