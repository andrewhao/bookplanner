class Plan < ActiveRecord::Base
  belongs_to :classroom
  has_many :assignments, dependent: :destroy
  has_one :inventory_state
  accepts_nested_attributes_for :assignments

  validates :classroom, presence: true
  validates :assignments, presence: true

  def book_bags
    # We can't do a `has_many :book_bags, through: :assignments`
    # because we need this to work on a nonpersisted object
    assignments.map(&:book_bag)
  end

  def active?
    inventory_state.present?
  end
end
