class InventoryState < ActiveRecord::Base
  belongs_to :plan
  has_and_belongs_to_many :book_bags
end
