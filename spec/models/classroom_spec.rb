require 'spec_helper'

describe Classroom do
  subject { FactoryGirl.create :classroom }

  before(:each) do
    @students = FactoryGirl.create_list :student, 2, classroom: subject
    @bags = FactoryGirl.create_list :book_bag, 3, classroom: subject
    @returned = Time.now
    @assignment1a = FactoryGirl.build :assignment,
      student: @students.first,
      book_bag: @bags.first,
      returned_at: @returned
    @assignment1b = FactoryGirl.build :assignment,
      student: @students.last,
      book_bag: @bags.last,
      returned_at: @returned
    @assignment2a = FactoryGirl.build :assignment,
      student: @students.first,
      book_bag: @bags.first
    @assignment2b = FactoryGirl.build :assignment,
      student: @students.last,
      book_bag: @bags.last
    @plan1 = FactoryGirl.create :plan,
      classroom: subject,
      assignments: [@assignment1a, @assignment1b]
    @plan2 = FactoryGirl.create :plan,
      classroom: subject,
      assignments: [@assignment2a, @assignment2b]
  end

  describe "#current_plan" do
    it "is the latest Plan" do
      expect(subject.current_plan).to eq @plan2
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
    before do
    end

    it "returns a list of book bags that have been returned and are available for the next cycle" do
      expect(subject.available_book_bags).to be_a Array
    end
  end

  describe "#eligible_students" do
    it "is pending"
  end
end

