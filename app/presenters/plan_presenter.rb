class PlanPresenter
  attr_accessor :plan

  def initialize(plan)
    @plan = plan
  end

  # FIXME/ahao Demeter violation!
  # Temporary fix while we refactor models.
  def name
    plan.period.name
  end
end
