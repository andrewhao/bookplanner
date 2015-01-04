class Student < ActiveRecord::Base
  belongs_to :classroom
  has_many :assignments

  def full_name
    "#{first_name} #{last_name}"
  end

  # TODO/move me to a aliased method
  def past_assignments
    assignments
  end

  scope :active, -> { where(inactive: false) }

end
