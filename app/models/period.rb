class Period < ActiveRecord::Base
  has_one :plan
  has_one :inventory_state, dependent: :destroy
  delegate :classroom, to: :plan

  after_initialize :initialize_name

  def periods_from(other)
    raise ArgumentError, "No period supplied" if other.nil?

    periods = classroom.periods
    my_idx = periods.index(self)
    prior_idx = periods.index(other)
    my_idx - prior_idx
  end

  private

  def initialize_name
    self.name ||= Date.today.to_s
  end
end
