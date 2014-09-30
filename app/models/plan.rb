class Plan < ActiveRecord::Base
  belongs_to :classroom
  has_many :assignments
end
