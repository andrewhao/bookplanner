class Student < ActiveRecord::Base
  belongs_to :classroom

  def full_name
    "#{first_name} #{last_name}"
  end
end
