class InventoryStateGenerator
  attr_accessor :params

  def initialize(params)
    @params = params
  end

  def generate
    is = InventoryState.create period: plan.period
    returned_assn = assignments.select{ |a| a[:on_loan] == "1" }
    returned_assn_ar = returned_assn.map{ |a| Assignment.find a[:id] }
    is.assignments = returned_assn_ar
    returned_assn_ar.each do |a|
      a.update_attributes(returned_at: Time.now)
    end
    is.save
    is
  end

  def assignments
    params[:inventory_state][:assignments_attributes].values
  rescue NoMethodError
    []
  end

  def success?
    true
  end

  def classroom
    classroom_id = params[:inventory_state][:classroom_id]
    Classroom.find classroom_id
  end

  def plan
    classroom.current_plan
  end
end
