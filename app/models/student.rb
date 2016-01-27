class Student < ActiveRecord::Base
  belongs_to :classroom
  has_many :assignments

  scope :name_sorted, -> { order(:first_name, :last_name) }
  scope :active, -> { where(inactive: false) }

  def full_name
    "#{first_name} #{last_name}"
  end

  # TODO/move me to a aliased method
  def past_assignments
    assignments
  end
end
