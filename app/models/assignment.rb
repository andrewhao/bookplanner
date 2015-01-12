class Assignment < ActiveRecord::Base
  belongs_to :student
  belongs_to :book_bag
  belongs_to :plan

  has_and_belongs_to_many :inventory_states

  validate :student, :book_bag, :plan, presence: true

  scope :display_sorted, -> { joins(:book_bag).order("book_bags.global_id ASC") }

  def on_loan?
    inventory_states.empty?
  end
end
