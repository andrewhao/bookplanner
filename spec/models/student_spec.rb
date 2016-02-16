require "spec_helper"

describe Student do
  subject { FactoryGirl.create(:student) }
  let(:book_bags) { FactoryGirl.create_list(:book_bag, 3, classroom: classroom) }
  let(:plans) { FactoryGirl.create_list(:plan_with_assignments, 3, classroom: classroom) }
  let(:classroom) { subject.classroom }

  describe "#past_assignments" do
    before do
      @past_assignment = FactoryGirl.create(:assignment,
                                            student: subject,
                                            book_bag: book_bags.first,
                                            plan: plans.first)
    end

    it "returns a list of assignments for the student" do
      expect(subject.past_assignments).to eq [@past_assignment]
    end
  end

  describe ".active" do
    it "returns all students who are active" do
      inactive = FactoryGirl.create :student, inactive: true
      expect(described_class.active).to eq [subject]
    end
  end

  describe ".name_sorted" do
    it "returns students in alpha order" do
      classroom = FactoryGirl.create :classroom
      student_1 = FactoryGirl.create :student, classroom: classroom, first_name: "b", last_name: "b"
      student_2 = FactoryGirl.create :student, classroom: classroom, first_name: "a", last_name: "b"
      student_3 = FactoryGirl.create :student, classroom: classroom, first_name: "a", last_name: "a"
      student_4 = FactoryGirl.create :student, classroom: classroom, first_name: "g"
      student_5 = FactoryGirl.create :student, classroom: classroom, first_name: "a", last_name: "c"
      expect(described_class.name_sorted).to eq [student_3,
                                                 student_2,
                                                 student_5,
                                                 student_1,
                                                 student_4]
    end
  end
end
