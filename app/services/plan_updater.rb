# Given a parameter hash from the request, we properly tear down, update,
# or recreate assignment and period information.
#
# Form object that takes in form params from PlanController#update
class PlanUpdater
  attr_reader :plan, :params
  delegate :period, to: :plan

  def initialize(plan, params)
    @plan = plan
    @params = params
  end

  def update
    return false unless updateable?
    ActiveRecord::Base.transaction do
      if has_assignment_attrs?
        destroy_assignments!
        create_assignments!
        plan.reload
      end
      plan.update(params)
    end
  end

  private

  def updateable?
    plan.active?
  end

  def destroy_assignments!
    plan.assignments.destroy_all
  end

  def has_assignment_attrs?
    params.key?(:assignments_attributes)
  end

  def create_assignments!
    attrs = params.delete(:assignments_attributes)
    new_query = {}
    attrs.values.each do |at|
      id_hash = at.extract!("id")
      at["plan_id"] = plan.id
      new_query[id_hash["id"]] = at
    end
    Assignment.create new_query.values
  end
end
