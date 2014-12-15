class Classroom < ActiveRecord::Base
  belongs_to :school
  has_many :students
  has_many :book_bags
  has_many :plans
  has_many :assignments, through: :plans

  def loaned_assignments
    assignments.where(returned_at: nil)
  end

  def available_book_bags
    []
  end

  def eligible_for_new_plan?
    !current_plan.active?
  end

  def current_plan
    plans.last
  end
end
