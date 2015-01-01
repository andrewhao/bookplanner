class ClassroomPresenter
  attr_accessor :classroom

  def initialize(classroom)
    @classroom = classroom
  end

  def students
    classroom.students.order(:first_name)
  end
end
