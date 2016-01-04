require "amb"

# A raw CSP solver
class AssignmentProblem
  attr_reader :student_ids, :bag_ids, :history_lookup, :debug, :logger, :template

  # @param [Array] student_ids Array of ints representing students
  # @param [Array] bag_ids Array of Integers representing bags
  # @param [Hash]  history_lookup Mapping of Integer => Array<Integer> where the
  #   key is the student ID and the value is an array of Bag IDs that
  #   the student has been assigned before.
  # @param [Boolean] debug (optional) Whether you want the logger
  # @param [Hash] template A predetermined set of assignments that the plan generator
  #   is expected to match as closely as possible to.
  def initialize(student_ids, bag_ids, history_lookup, debug: true, logger: nil, template: {})
    @student_ids = student_ids
    @bag_ids = bag_ids
    @history_lookup = history_lookup
    @debug = debug
    @template = template
    @logger = logger || Proc.new { |msg| Rails.logger.info(msg) if debug }

    log <<-LOG
    Initializing:
      students: #{student_ids}
      bags:     #{bag_ids}
      history:  #{history_lookup}
      template: #{template}
    LOG
  end

  # Generates tuples of student => bag assignments
  def solve
    # Generate uniques
    spaces = student_ids.product(bag_ids)
    solver.assert spaces.any?

    begin
      plan = StandardSolverStrategy.new
        .generate_plan(template,
                       bag_ids,
                       student_ids,
                       history_lookup,
                       debug,
                       solver,
                       logger).to_a
    rescue Amb::ExhaustedError
      plan = []
    end

    return plan if plan.any?

    IterativeRelaxingConstraintSolverStrategy.new
        .generate_plan(template,
                       bag_ids,
                       student_ids,
                       history_lookup,
                       debug,
                       solver,
                       logger).to_a
  end

  def log(msg)
    logger.call(msg)
  end

  class Solver
    include Amb
  end

  def solver
    @solver ||= Solver.new
  end
end
