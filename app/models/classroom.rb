class Classroom < ActiveRecord::Base
  belongs_to :school
  has_many :students
  has_many :book_bags
  has_many :plans
end
