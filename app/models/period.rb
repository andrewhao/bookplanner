class Period < ActiveRecord::Base
  has_one :plan
  has_one :inventory_state, dependent: :destroy
  delegate :classroom, to: :plan

  after_initialize :initialize_name

  private

  def initialize_name
    self.name ||= Date.today.to_s
  end

  # TODO/ahao
  # This association should belong_to :classroom, then move association off of plan.
end
