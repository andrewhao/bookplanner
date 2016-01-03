class Plan < ActiveRecord::Base
  belongs_to :period, autosave: true, dependent: :destroy
  has_one :classroom, through: :period
  has_many :assignments, -> { joins(:student).order('students.first_name DESC') }, dependent: :destroy
  has_one :inventory_state, through: :period

  accepts_nested_attributes_for :period
  accepts_nested_attributes_for :assignments

  validates :assignments, presence: true

  after_initialize :initialize_period

  delegate :name, to: :period

  def book_bags
    # We can't do a `has_many :book_bags, through: :assignments`
    # because we need this to work on a nonpersisted object
    assignments.map(&:book_bag)
  end

  def ordered_book_bags
    book_bags.sort_by(&:global_id)
  end

  def active?
    inventory_state.nil?
  end
  alias_method :editable?, :active?

  def closed?
    inventory_state.present?
  end

  def presenter
    @presenter ||= PlanPresenter.new(self)
  end

  def initialize_period
    self.period ||= Period.new
  end

  def template
    Hash[assignments.map(&:to_plan_array)]
  end
end
