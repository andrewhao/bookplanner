class PlanPresenter
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::OutputSafetyHelper

  attr_accessor :plan

  delegate :assignments, to: :plan

  def initialize(plan)
    @plan = plan
  end

  def display_cell_for(student)
    assignment = assignments.where(student_id: student.id).try(:first)
    id = assignment.try(:book_bag).try(:global_id)
    return id if id
    content_tag(:span, raw("&mdash;"), class: "text-muted")
  end

  # FIXME/ahao Demeter violation!
  # Temporary fix while we refactor models.
  def name
    plan.period.name
  end
end
