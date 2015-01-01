class Plan < ActiveRecord::Base
  belongs_to :classroom
  has_many :assignments, -> { joins(:student).order('students.first_name DESC') }, dependent: :destroy
  has_one :inventory_state, through: :period
  accepts_nested_attributes_for :assignments

  validates :classroom, presence: true
  validates :assignments, presence: true

  belongs_to :period, dependent: :destroy

  before_create :create_period

  def book_bags
    # We can't do a `has_many :book_bags, through: :assignments`
    # because we need this to work on a nonpersisted object
    assignments.map(&:book_bag)
  end

  def active?
    inventory_state.nil?
  end

  def create_period
    p = Period.create
    self.period = p
  end
end
