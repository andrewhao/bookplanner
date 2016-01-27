require "spec_helper"

describe ClassroomPresenter do
  let(:classroom) { FactoryGirl.create :classroom }
  let(:period) { FactoryGirl.create(:period) }
  let(:plan) { FactoryGirl.create(:plan_with_assignments, period: period) }
  let(:student) { assignments.first.student }
  let(:assignments) { plan.assignments }
  subject { described_class.new(classroom) }

  before do
    plan
  end

  describe "#students" do
    it "returns students in alpha order" do
      student_1 = FactoryGirl.create :student, classroom: classroom, first_name: "b", last_name: "b"
      student_2 = FactoryGirl.create :student, classroom: classroom, first_name: "a", last_name: "b"
      student_3 = FactoryGirl.create :student, classroom: classroom, first_name: "a", last_name: "a"
      student_4 = FactoryGirl.create :student, classroom: classroom, first_name: "g"
      student_5 = FactoryGirl.create :student, classroom: classroom, first_name: "a", last_name: "c"
      expect(subject.students).to eq [student_3,
                                      student_2,
                                      student_5,
                                      student_1,
                                      student_4]
    end
  end

  describe "#header_cell_for" do
    it "returns HTML" do
      output_html = <<-HTML
<th></th>
      HTML
      output_html.strip!
      expect(subject.header_cell_for(student)).to eq output_html
    end

    it "returns special class for inactive student" do
      student.update_attributes(inactive: true)
      output_html = <<-HTML
<th class=\"text-muted bg-danger\"></th>
      HTML
      output_html.strip!
      expect(subject.header_cell_for(student)).to eq output_html
    end

    it "renders random text from the return value of block" do
      expect(
        subject.header_cell_for(student) { "foo" }
      ).to include "foo"
    end
  end

  describe "#header_cell_icon" do
    context "for inactive student" do
      let(:student) { FactoryGirl.create :student, inactive: true }

      it "returns the inactive icon" do
        output_html = "glyphicon glyphicon-question-sign"
        expect(subject.header_cell_icon(student)).to include output_html
      end
    end

    context "for active but ineligible student" do
      it "returns the ineligible icon" do
        expect_any_instance_of(Classroom).to receive(:eligible_students).and_return([])
        output_html = "glyphicon glyphicon-log-out"
        expect(subject.header_cell_icon(student)).to include output_html
      end
    end

    context "for active and eligible student" do
      it "returns nil" do
        expect_any_instance_of(Classroom).to receive(:eligible_students).and_return([student])
        expect(subject.header_cell_icon(student)).to be_nil
      end
    end
  end
end
