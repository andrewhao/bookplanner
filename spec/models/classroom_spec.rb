require 'spec_helper'

describe Classroom do
  subject { create :classroom }

  before(:each) do
    @period1, @period2 = create_list :period, 2, classroom: subject
    @students = [
      create(:student, classroom: subject, first_name: 'Jonathan', last_name: 'Ochoa'),
      create(:student, classroom: subject, first_name: 'Ada'),
      create(:student, classroom: subject, first_name: 'Jonathan', last_name: 'Franzo')
    ]
    @bags = create_list :book_bag, 3, classroom: subject
    @returned = Time.now
    @assignment1a = build :assignment,
      student: @students.first,
      book_bag: @bags.first
    @assignment1b = build :assignment,
      student: @students.last,
      book_bag: @bags.last
    @assignment2a = build :assignment,
      student: @students.first,
      book_bag: @bags.first
    @assignment2b = build :assignment,
      student: @students.last,
      book_bag: @bags.last
    @plan1 = create :plan_with_assignments,
      classroom: subject,
      assignments: [@assignment1a, @assignment1b],
      period: @period1
    @plan2 = create :plan_with_assignments,
      classroom: subject,
      assignments: [@assignment2a, @assignment2b],
      period: @period2
    @inventory_state1 = create(:inventory_state, period: @period1)
    @inventory_state1.assignments += [@assignment1a, @assignment1b]
  end

  describe "#inventory_states" do
    it "returns correct associations" do
      expect(subject.inventory_states).to eq [@inventory_state1]
    end
  end

  describe "#active_students" do
    it "returns only students that are active" do
      @inactive_student = create :student, inactive: true
      expect(subject.active_students).to match_array @students
    end
  end

  describe "#current_plan" do
    it "is the latest Plan" do
      expect(subject.current_plan).to eq @plan2
    end
  end

  describe "#current_period" do
    it "is the latest period" do
      expect(subject.current_period).to eq @plan2.period
    end

    it "is the latest period for this class" do
      other_plan = create :plan_with_assignments
      expect(subject.current_period).to eq @plan2.period
    end
  end

  describe "#presenter" do
    it "returns a ClassroomPresenter" do
      expect(subject.presenter).to be_instance_of(ClassroomPresenter)
    end
  end

  describe "#display_plans" do
    it "returns reverse chronological order of plans" do
      expect(subject.display_plans).to eq [@plan2, @plan1]
    end
  end

  describe "#eligible_for_new_plan?" do
    it "is eligible if the past plan has finished" do
      expect_any_instance_of(Plan).to receive(:active?).and_return(false)
      expect(subject).to be_eligible_for_new_plan
    end

    it "is not eligible if the past plan is still active" do
      expect_any_instance_of(Plan).to receive(:active?).and_return(true)
      expect(subject).to_not be_eligible_for_new_plan
    end

    it "is eligible if there are no plans" do
      classroom = create(:classroom)
      expect(classroom).to be_eligible_for_new_plan
    end
  end

  describe "#to_param" do
    it "returns id-title slug" do
      subject.name = "Mrs. Smith"
      expect(subject.to_param).to eq "#{subject.id}-mrs-smith"
    end
  end

  describe "#loaned_assignments" do
    it "returns a list of assignments that are out on loan" do
      expect(subject.loaned_assignments).to include @assignment2a
      expect(subject.loaned_assignments).to include @assignment2b
      expect(subject.loaned_assignments).to_not include @assignment1a
      expect(subject.loaned_assignments).to_not include @assignment1b
    end
  end

  describe "#available_book_bags" do
    it "returns a list of book bags that have been returned and are available for the next cycle" do
      expect(subject.available_book_bags).to include @bags[1]
      expect(subject.available_book_bags).to_not include @assignment2a.book_bag
      expect(subject.available_book_bags).to_not include @assignment2b.book_bag
    end

    it "takes into account book bags that have been checked out on a previous cycle" do
      assignment1c = create :assignment,
        student: @students[1],
        book_bag: @bags[1],
        plan: @plan1
      expect(subject.available_book_bags).not_to include @bags[1]
    end

    it "excludes book bags that are inactive" do
      inactive_bag = create(:book_bag, classroom: subject, active: false)
      expect(subject.available_book_bags).to_not include inactive_bag
    end
  end

  describe "#eligible_students" do
    it "shows students who do not have any outstanding assignments" do
      expect(subject.eligible_students).to eq [@students[1]]
    end
  end

  describe "#returned_assignments" do
    it "lists all assignments that have been returned" do
      expect(subject.returned_assignments).to match_array [@assignment1a, @assignment1b]
    end
  end

  describe "#periods" do
    it "returns an array of Periods" do
      expect(subject.periods).to be_all{|p| p.is_a?(Period)}
    end
  end
end
