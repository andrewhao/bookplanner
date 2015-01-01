class PlanPresenter
  attr_accessor :plan

  def initialize(plan)
    @plan = plan
  end

  def assignments
    plan.assignments
  end
end
