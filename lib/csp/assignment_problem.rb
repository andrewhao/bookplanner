require "amb"

# A raw CSP solver
class AssignmentProblem
  attr_reader :student_ids, :bag_ids, :history_lookup, :debug, :logger

  # @param [Array] student_ids Array of ints representing students
  # @param [Array] bag_ids Array of Integers representing bags
  # @param [Hash]  history_lookup Mapping of Integer => Array<Integer> where the
  #   key is the student ID and the value is an array of Bag IDs that
  #   the student has been assigned before.
  # @param [Boolean] debug (optional) Whether you want the logger
  def initialize(student_ids, bag_ids, history_lookup, debug: true, logger: nil)
    @student_ids = student_ids
    @bag_ids = bag_ids
    @history_lookup = history_lookup
    @debug = debug
    @logger = logger || Proc.new { |msg| Rails.logger.info(msg) }

    if debug
      log <<-LOG
    Initializing history:
      students: #{student_ids}
      bags:     #{bag_ids}
      history:  #{history_lookup}
    LOG
    end
  end

  # Generates tuples of student => bag assignments
  def solve
    # Generate uniques
    spaces = student_ids.product(bag_ids)

    solver.assert spaces.any?

    visited_nodes = 0
    plan = {}
    student_ids.each do |sid|
      bid = solver.choose(*bag_ids)
      log "I choose #{bid} for student #{sid}" if debug

      temp_plan = plan.clone
      temp_plan[sid] = bid
      visited_nodes += 1
      # Problem is that when we backtrack, we have to clear out the current selection.
      log "* #{temp_plan}" if debug
      solver.assert assigned_bags_are_unique(temp_plan)
      solver.assert assigned_bags_without_student_repeats(temp_plan)
      plan[sid] = bid
    end

    log "Visited: #{visited_nodes} nodes" if debug
    plan.to_a
  end

  def log(msg)
    logger.call(msg)
  end

  def bag_choices_for_student(sid)
    used_bids = history_lookup[sid]
    bag_ids - used_bids
  end

  def assigned_bags_are_unique(plan)
    val = plan.values.uniq.count == plan.values.count
    log "Is this an unassigned bag?: #{val}" if debug
    val
  end

  def assigned_bags_without_student_repeats(plan)
    val = plan.none? do |assignment|
      student_id, bag_id = assignment
      history = history_lookup[student_id]
      history.include?(bag_id)
    end
    log "Never assigned before to student?: #{val}" if debug
    val
  end

  class Solver
    include Amb
  end

  def solver
    @solver ||= Solver.new
  end
end

