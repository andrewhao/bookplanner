require 'spec_helper'

describe PlanRegenerator do
  let(:book_bags) { create_list(:book_bag, 2) }
  let(:bag1) { book_bags.first }
  let(:bag2) { book_bags.second }
  let(:student1) { students.first }
  let(:student2) { students.last }

  let(:students) { create_list(:student, 2) }
  let(:classroom) { create(:classroom, book_bags: book_bags, students: students) }
  let!(:assignment) { create(:assignment, book_bag: bag1, student: student1) }
  let!(:assignment2) { create(:assignment, book_bag: bag2, student: student2) }
  let(:current_period) { create(:period, classroom: classroom) }
  let(:plan) { create(:plan, assignments: [assignment, assignment2], period: current_period) }
  subject { described_class.new(plan) }

  it 'deletes a plan' do
    subject.regenerate
    expect {
      plan.reload
    }.to raise_error ActiveRecord::RecordNotFound
  end

  it 'deletes the plan assignments' do
    subject.regenerate

    expect {
      assignment.reload
    }.to raise_error ActiveRecord::RecordNotFound
  end

  it 'creates a new plan' do
    new_plan = subject.regenerate
    new_plan.reload
    expect(new_plan.id).to be > plan.id
    expect(new_plan.period).to eq current_period
  end

  it 'calls the PlanGenerator with a template' do
    generator = instance_double(PlanGenerator)
    template = { student1.id => bag1.id, student2.id => bag2.id }
    expect(PlanGenerator).to receive(:new)
      .with(array_including(students),
            array_including(book_bags),
            template: template)
      .and_return(generator)

    expect(generator).to receive(:generate).and_return([create(:assignment)])

    subject.regenerate
  end

  it 'raises a PlanNotFound exception if the Regenerator fails' do
    subject.regenerate
  end

  describe '#delta' do
    it 'returns an empty string when nothing changes' do
      subject.regenerate
      expect(subject.delta).to eq ''
    end
  end
end
