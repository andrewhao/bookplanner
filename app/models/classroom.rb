class Classroom < ActiveRecord::Base
  belongs_to :school
  has_many :students, dependent: :destroy
  has_many :book_bags, dependent: :destroy
  has_many :plans, dependent: :destroy
  has_many :assignments, -> { joins(:student) }, through: :plans
  has_many :inventory_states, through: :plans
  has_many :returned_assignments, through: :inventory_states, source: :assignments
  has_many :periods, through: :plans

  # All assignments that are out on loan
  # This can likely be rewritten in SQL
  def loaned_assignments
    assignments - returned_assignments
  end

  def available_book_bags
    book_bags - loaned_assignments.map(&:book_bag)
  end

  def eligible_for_new_plan?
    !current_plan.active?
  end

  def current_plan
    plans.last
  end

  def active_students
    students.active
  end

  def eligible_students
    students - loaned_assignments.map(&:student)
  end
end
