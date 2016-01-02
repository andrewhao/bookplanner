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
    rescue Amb::ExhaustedError => e
      plan = []
    end

    return plan if plan.any?

    IterativeRelaxingConstraintStrategy.new
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

  class StandardSolverStrategy
    def generate_plan(temp_template, bag_ids, student_ids, history_lookup, debug, solver, logger)
      visited_nodes = 0
      plan = {}
      student_ids.each do |sid|
        bid = temp_template[sid] || solver.choose(*bag_ids)
        logger.call "I choose #{bid} for student #{sid}"

        temp_plan = plan.clone
        temp_plan[sid] = bid
        visited_nodes += 1
        # Problem is that when we backtrack, we have to clear out the current selection.
        logger.call "* #{temp_plan}"
        solver.assert assigned_bags_are_unique(temp_plan, logger, history_lookup)
        solver.assert assigned_bags_without_student_repeats(temp_plan, logger, history_lookup)
        plan[sid] = bid
      end
      logger.call "Visited: #{visited_nodes} nodes"
      plan
    end

    private

    def assigned_bags_are_unique(plan, logger, history_lookup)
      val = plan.values.uniq.count == plan.values.count
      logger.call "Is this an unassigned bag?: #{val}"
      val
    end

    def assigned_bags_without_student_repeats(plan, logger, history_lookup)
      val = plan.none? do |assignment|
        student_id, bag_id = assignment
        history = history_lookup[student_id]
        history.include?(bag_id)
      end
      logger.call "Never assigned before to student?: #{val}"
      val
    end
  end

  class IterativeRelaxingConstraintStrategy
    def generate_plan(template, bag_ids, student_ids, history_lookup, debug, solver, logger)
      plan = {}

      template_exclusion_bag_ids = template.values
      template_exclusion_bag_ids.reduce(template.clone) do |temp_template, bag_id|
        logger.call "Begin:"
        logger.call "Template: #{temp_template}"
        logger.call "Bag: #{bag_id}"
        begin
          remaining_bag_ids = temp_template.values
          next_exclusion_bag_id = solver.choose(*remaining_bag_ids)
          temp_template = temp_template.reject{|sid, bid| bid == next_exclusion_bag_id}
          logger.call "I choose to exclude #{next_exclusion_bag_id}, rendering the template #{temp_template}"

          plan = StandardSolverStrategy.new.generate_plan(temp_template, bag_ids, student_ids, history_lookup, debug, solver, logger)
        rescue Amb::ExhaustedError => e
          logger.call e.message
        end
        break if plan.any?
        temp_template
      end

      return plan
    end
  end
end
