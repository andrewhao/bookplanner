class Plan < ActiveRecord::Base
  belongs_to :classroom
  has_many :assignments
  accepts_nested_attributes_for :assignments
end
