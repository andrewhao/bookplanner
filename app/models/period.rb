class Period < ActiveRecord::Base
  has_one :plan
  has_one :inventory_state, dependent: :destroy
  belongs_to :classroom

  after_initialize :initialize_name

  def periods_from(other)
    raise ArgumentError, "No period supplied" if other.nil?

    periods = classroom.periods.order(:created_at)
    my_idx = periods.index(self)
    prior_idx = periods.index(other)
    my_idx - prior_idx
  end

  def before?(other)
    self.created_at < other.created_at
  end

  def active?
    plan.present? && inventory_state.nil?
  end

  def closed?
    plan.present? && inventory_state.present?
  end

  private

  def initialize_name
    self.name ||= Date.today.to_s
  end
end
