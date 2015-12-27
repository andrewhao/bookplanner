class AssignmentsController < ApplicationController
  def update
    assignment = Assignment.find(params[:id])
    plan = Plan.find(params[:plan_id])
    updater = UpdatePlanWithLateReturn.new(assignment: assignment, current_plan: plan)
    updater.update!
    if updater.success?
      flash[:notice] = updater.message
      redirect_to classroom_path(assignment.plan.classroom)
    else
      flash[:alert] = updater.message
      redirect_to :back
    end
  end
end
