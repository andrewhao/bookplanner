# Group of assignments that have been returned in a certain period at its close.
# Think about this as a reverse plan
class InventoryState < ActiveRecord::Base
  has_and_belongs_to_many :assignments
  belongs_to :period
  delegate :plan, to: :period
end
