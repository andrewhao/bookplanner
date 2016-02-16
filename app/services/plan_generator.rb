# Generates a set of assignments that satisfy the constraint that
# all students receive a unique bag assignment.
#
# Acts as an adapter layer between the CSP solver and AR models.
class PlanGenerator
  attr_reader :students, :bags, :bag_history_lookup, :template

  # @param [Array] students An array of Students
  # @param [Array] bags An array of BookBags
  def initialize(students, bags, template: {})
    @students = students
    @bags = bags
    @bag_history_lookup = {}
    @students.each do |s|
      history = s.past_assignments.map(&:book_bag_id)
      @bag_history_lookup[s.id] = history
    end
    @template = template
  end

  # Generates a set of Assignments for a given set of students and bags.
  def generate
    # To simplify algorithm and reduce memory usage, reduce all objects to
    # primitive data types.
    student_ids = students.map(&:id)
    bag_ids = bags.map(&:id)

    ap = AssignmentProblem.new(student_ids,
                               bag_ids,
                               @bag_history_lookup,
                               template: template,
                               debug: true)
    plan = ap.solve

    if plan.empty?
      raise NoPlanFound.new("Unable to generate a plan. Please add a bag.")
    end

    plan.map do |sid, bid|
      Assignment.new(student: Student.find(sid), book_bag: BookBag.find(bid))
    end
  end

  private

  # Raised when it's impossible to find a plan, and the user needs
  # to be prompted about it.
  class NoPlanFound < StandardError; end
end
