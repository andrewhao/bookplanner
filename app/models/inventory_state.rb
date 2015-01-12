# Group of assignments that have been returned in a certain period at its close.
# Think about this as a reverse plan
class InventoryState < ActiveRecord::Base
  has_and_belongs_to_many :assignments, -> { joins(:book_bag).order("book_bags.global_id ASC") }
  belongs_to :period
  delegate :plan, :classroom, to: :period
  accepts_nested_attributes_for :assignments

  # Virtual placeholder to define initial attributes.
  # This object is used to prepopulate the inventory check-in UI.
  def self.new_from_plan(plan)
    i = self.new
    i.period = plan.period
    i.assignments += plan.assignments
    i
  end

  def sorted_assignments
    assignments.sort_by{ |a| a.book_bag.global_id }
  end

  # For simple_form's benefit.
  def classroom_id
    classroom.id
  end
end
