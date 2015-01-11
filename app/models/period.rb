class Period < ActiveRecord::Base
  has_one :plan
  has_one :inventory_state, dependent: :destroy
  delegate :classroom, to: :plan

  # TODO/ahao
  # This association should belong_to :classroom, then move association off of plan.
end
