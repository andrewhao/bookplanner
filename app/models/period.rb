class Period < ActiveRecord::Base
  has_one :plan
  has_one :inventory_state, dependent: :destroy
end
