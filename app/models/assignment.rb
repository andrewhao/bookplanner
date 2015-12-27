# A checkout of a book bag to a student
# It is marked as "checked out" if it has been associated with a plan
# It is marked as "returned" if it has been associated with both a plan and an inventory state.
class Assignment < ActiveRecord::Base
  belongs_to :student
  belongs_to :book_bag
  belongs_to :plan
  belongs_to :inventory_state

  validate :student, :book_bag, :plan, presence: true

  scope :display_sorted, -> { joins(:book_bag).order("book_bags.global_id ASC") }

  def loaned_period
    plan.period
  end

  def returned_period
    inventory_state.try(&:period)
  end

  def on_loan?
    inventory_state.blank?
  end

  def display_info_brief
    "#{student.full_name} assigned Book Bag #{book_bag.global_id}"
  end

  def display_info
    "#{student.full_name} still has bag ##{book_bag.global_id} checked out since #{loaned_period.name}"
  end
end
