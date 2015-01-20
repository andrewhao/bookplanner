# Given a parameter hash from the request, we properly tear down, update,
# or recreate assignment and period information.
class PlanUpdater
  attr_reader :plan, :params
  delegate :period, to: :plan

  def initialize(plan, params)
    @plan = plan
    @params = params
  end

  def update
    #update_assignment!
    ActiveRecord::Base.transaction do
      plan.update(params)
    end
  end

  def update_assignment!
    attrs = params.delete(:assignments_attributes)
    return if attrs.nil?
    new_query = {}
    attrs.values.each do |at|
      id_hash = at.extract!("id")
      new_query[id_hash["id"]] = at
    end
    Assignment.update new_query.keys new_query.values
  end
end
