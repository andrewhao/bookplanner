require "amb"

# A raw CSP solver
class AssignmentProblem
  attr_reader :student_ids, :bag_ids, :history_lookup, :partial_plan

  # @param [Array] Array of ints representing students
  # @param [Array] Array of Integers representing bags
  # @param [Hash] Mapping of Integer => Array<Integer> where the
  #   key is the student ID and the value is an array of Bag IDs that
  #   the student has been assigned before.
  def initialize(student_ids, bag_ids, history_lookup)
    @student_ids = student_ids
    @bag_ids = bag_ids
    @history_lookup = history_lookup
    @partial_plan = {}
  end

  # Generates tuples of student => bag assignments
  def solve
    # Generate uniques
    spaces = student_ids.product(bag_ids)

    visited_nodes = 0
    student_ids.each do |sid|
      bid = solver.choose(*bag_choices_for_student(sid))
      visited_nodes +=1
      partial_plan[sid] =  bid
      solver.assert assigned_bags_are_unique(partial_plan)
      solver.assert assigned_bags_without_student_repeats(partial_plan)
    end

    puts "Visited: #{visited_nodes} nodes"
    partial_plan.to_a
  end

  def bag_choices_for_student(sid)
    used_bids = history_lookup[sid]
    bag_ids - used_bids
  end

  def assigned_bags_are_unique(plan)
    plan.values.uniq.count == plan.values.count
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

