require "spec_helper"

describe InventoryStateGenerator do
  let(:params) do
    {
      inventory_state:
        { classroom_id: classroom.id }
    }
  end
  let(:classroom) { FactoryGirl.create :classroom }
  let(:plan) { FactoryGirl.create :plan_with_assignments, classroom: classroom }
  let(:assignments) { plan.assignments }

  subject { described_class.new(params) }

  before do
    plan
  end

  describe "#generate" do
    it "creates a new plan" do
      expect {
        subject.generate
      }.to change(InventoryState, :count).by(1)
    end

    it "assigns IS with correct params" do
      expect(subject.generate.period).to eq plan.period
    end

    context "for mixed assignment params" do
      let(:a1) { assignments[0] }
      let(:a2) { assignments[1] }

      let(:params) do
        {"inventory_state"=>
         {"classroom_id"=>classroom.id,
          "assignments_attributes"=>
         {"0"=>{"student_id"=>a1.student_id.to_s, "on_loan"=>"1", "id" => a1.id},
          "1"=>{"student_id"=>a2.student_id.to_s, "on_loan"=>"0", "id" => a2.id}}}}.with_indifferent_access
      end

      it "adds a1 to inventory state but not a2" do
        subject.generate
        is = InventoryState.last
        expect(is.assignments).to eq [a1]
      end
    end
  end
end
