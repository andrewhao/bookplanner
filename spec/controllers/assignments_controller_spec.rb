require "spec_helper"

describe AssignmentsController, type: :controller do
  describe '#update' do
    let(:classroom) { FactoryGirl.create(:classroom) }
    let(:plan) { FactoryGirl.create(:plan_with_assignments, classroom: classroom) }
    let(:assignment) { plan.assignments.first }

    it "passes the Assignment to the LateReturnPlanUpdater" do
      mock_updater = instance_double(UpdatePlanWithLateReturn, update!: true, success?: true, message: "")
      expect(UpdatePlanWithLateReturn).to receive(:new).
        with(assignment: assignment, current_plan: plan).
        and_return(mock_updater)

      put :update, id: assignment.id, plan_id: plan.id
    end

    it "redirects to the plan matrix" do
      mock_updater = instance_double(UpdatePlanWithLateReturn, update!: true, success?: true, message: "")
      expect(UpdatePlanWithLateReturn).to receive(:new).
        with(assignment: assignment, current_plan: plan).
        and_return(mock_updater)

      put :update, id: assignment.id, plan_id: plan.id
      expect(response).to redirect_to(classroom_path(assignment.plan.classroom))
    end

    context "failure" do
      it "redirects back" do
        referrer = "http://localhost"
        request.env["HTTP_REFERER"] = referrer

        mock_updater = instance_double(UpdatePlanWithLateReturn, update!: true, success?: false, message: "")
        expect(UpdatePlanWithLateReturn).to receive(:new).
          with(assignment: assignment, current_plan: plan).
          and_return(mock_updater)

        put :update, id: assignment.id, plan_id: plan.id
        expect(response).to redirect_to referrer
      end
    end
  end
end
