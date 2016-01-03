require 'spec_helper'

describe UpdatePlanWithLateReturn do
  let(:book_bags) { create_list(:book_bag, 3) }
  let(:bag1) { book_bags.first }
  let(:bag2) { book_bags.second }
  let(:bag3) { book_bags.last }
  let(:students) { create_list(:student, 2) }
  let(:classroom) { create(:classroom, book_bags: book_bags, students: students) }

  let(:old_period) { create(:period, created_at: Time.zone.parse("2015-01-01"), classroom: classroom) }
  let(:last_period) { create(:period, created_at: Time.zone.parse("2015-01-15"), classroom: classroom) }
  let(:current_period) { create(:period, created_at: Time.zone.parse("2015-02-01"), classroom: classroom) }

  let!(:old_plan) { create(:plan, period: old_period, assignments: [old_returned_assignment, assignment]) }
  let!(:last_plan) { create(:plan, period: last_period, assignments: [last_returned_assignment]) }
  let!(:current_plan) { create(:plan, assignments: [assignment2], period: current_period) }

  let!(:assignment) { create(:assignment, book_bag: bag3, student: students.last) }
  let!(:assignment2) { create(:assignment, book_bag: bag1, student: students.first) }

  let!(:old_returned_assignment) { create(:assignment, book_bag: bag1, student: students.first) }
  let!(:last_returned_assignment) { create(:assignment, book_bag: bag2, student: students.first) }

  let!(:old_inventory_state) { create(:inventory_state, assignments: [old_returned_assignment], period: old_period) }
  let!(:last_inventory_state) { create(:inventory_state, assignments: [last_returned_assignment], period: last_period) }
  subject { described_class.new(assignment: assignment, current_plan: current_plan) }

  before do
    expect(assignment2).to be_on_loan
    expect(assignment).to be_on_loan
  end

  describe '#update!' do
    it 'adds assignment to the last open inventory state' do
      subject.update!

      expect(assignment.reload.returned_at).to_not be_nil
      expect(last_inventory_state.reload.assignments).to include assignment
    end

    it 'indicates that it was successful' do
      subject.update!
      expect(subject).to be_success
    end

    it 'creates a new assignment for the latest plan' do
      expect {
        subject.update!
      }.to change { Assignment.count }.by(1)
    end

    context 'on failure (no possible assignments)' do
      it 'rolls back the transaction' do
        expect_any_instance_of(PlanGenerator).to receive(:generate).and_raise PlanGenerator::NoPlanFound.new
        expect {
          subject.update!
        }.to_not change { Assignment.count }
        expect(last_inventory_state.reload.assignments).to_not include assignment
      end

      it 'returns an error code' do
        expect_any_instance_of(PlanGenerator).to receive(:generate).and_raise PlanGenerator::NoPlanFound.new
        subject.update!
        expect(subject).to_not be_success
      end
    end
  end
end
