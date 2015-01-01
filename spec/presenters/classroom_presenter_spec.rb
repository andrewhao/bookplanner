require "spec_helper"

describe ClassroomPresenter do
  describe "#students" do
    it "returns students in alpha order" do
      classroom = FactoryGirl.create :classroom
      student_end = FactoryGirl.create :student, classroom: classroom, first_name: "zzzz"
      student_begin = FactoryGirl.create :student, classroom: classroom, first_name: "aaaa"
      student_mid = FactoryGirl.create :student, classroom: classroom, first_name: "gggg"
      presenter = ClassroomPresenter.new(classroom)
      expect(presenter.students).to eq [student_begin, student_mid, student_end]
    end
  end
end
