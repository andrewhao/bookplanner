require "spec_helper"

describe PlanUpdater do
  let(:plan) { FactoryGirl.create :plan_with_assignments }
  subject { described_class.new(plan, params) }
  let(:period) { plan.period }
  let(:assignments) { plan.assignments }

  let(:params) do
    {
      period_attributes: {
        name: new_name,
        id: period.id
      }
    }
  end

  let(:new_name) { "Week Sixteen" }

  describe "#update" do
    context "field updates on Period" do
      it "updates a period name given param input" do
        expect {
          subject.update
        }.to change { period.reload.name }.to(new_name)
      end
    end

    context "assignments that already exist" do
      let(:params) do
        attrs = {}
        bag_ids = assignments.map(&:book_bag_id)
        assignments.each_with_index do |a, i|
          rotated_bag_idx = (i + 1) % assignments.length
          attrs[i] = a.attributes.extract!("id", "student_id", "book_bag_id")
          attrs[i]["book_bag_id"] = bag_ids[rotated_bag_idx]
        end
        {
          assignments_attributes: attrs
        }
      end

      it "allows swapping" do
        expect {
          subject.update
        }.to_not raise_error
      end
    end
  end
end
