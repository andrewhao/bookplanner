require 'spec_helper'

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
end
