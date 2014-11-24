class Plan < ActiveRecord::Base
  belongs_to :classroom
  has_many :assignments, dependent: :destroy
  accepts_nested_attributes_for :assignments

  validate :classroom, presence: true
end
