class ClassroomPresenter
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::OutputSafetyHelper

  attr_accessor :classroom

  def initialize(classroom)
    @classroom = classroom
  end

  def students
    classroom.students.order(:first_name)
  end

  def header_cell_icon(student)
    is_eligible = classroom.eligible_students.include?(student)
    return nil if (!student.inactive? && is_eligible)
    if student.inactive?
      extra_class = "glyphicon-question-sign"
      help_text = "This student has not yet turned in his or her permission slip and is inactive."
    elsif !is_eligible
      extra_class = "glyphicon-log-out"
      help_text = "This student still has a book out on loan."
    end
    return content_tag(:span, "", {:class => "pull-right glyphicon #{extra_class}", :"aria-hidden" => true, title: help_text})
  end

  def header_cell_for(student, &block)
    content_tag(:th, (block_given? ? yield : ""), class: (student.inactive? ? "text-muted bg-danger" : nil))
  end
end
