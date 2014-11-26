# A raw CSP solver
class AssignmentProblem
  attr_reader :student_ids, :bag_ids, :history_lookup

  # @param [Array] Array of ints representing students
  # @param [Array] Array of Integers representing bags
  # @param [Hash] Mapping of Integer => Array<Integer> where the
  #   key is the student ID and the value is an array of Bag IDs that
  #   the student has been assigned before.
  def initialize(student_ids, bag_ids, history_lookup)
    @student_ids = student_ids
    @bag_ids = bag_ids
    @history_lookup = history_lookup
  end

  def solve
    # Generate uniques
    spaces = student_ids.product(bag_ids)

    # Now generate combinations of those uniques
    full_solution_space = spaces.permutation(student_ids.count).to_a

    # Assign those to the CSP
    plan = solver.choose(*full_solution_space)

    solver.assert all_students_have_bags(plan)
    solver.assert assigned_bags_are_unique(plan)
    solver.assert assigned_bags_without_student_repeats(plan)

    plan
  end

  # All students receive a bag in this plan
  def all_students_have_bags(plan)
    plan.map(&:first).uniq.count == student_ids.count
  end

  def assigned_bags_are_unique(plan)
    plan.map(&:last).uniq.count == plan.count
  end

  def assigned_bags_without_student_repeats(plan)
    plan.none? do |assignment|
      student_id, bag_id = assignment
      history = history_lookup[student_id]
      history.include?(bag_id)
    end
  end

  class Solver
    include Amb
  end

  def solver
    @solver ||= Solver.new
  end
end

