class Assignment < ActiveRecord::Base
  belongs_to :student
  belongs_to :book_bag

  # TODO/ahao refactor data model to mirror inventory state's HABTM table
  belongs_to :plan

  has_and_belongs_to_many :inventory_states

  validate :student, :book_bag, :plan, presence: true

  scope :display_sorted, -> { joins(:book_bag).order("book_bags.global_id ASC") }

  def loaned_period
    plan.period
  end

  def returned_period
    nil
  end

  def on_loan?
    inventory_states.empty?
  end

  def display_info
    "#{student.full_name} still has bag ##{book_bag.global_id} checked out since #{loaned_period.name}"
  end
end
