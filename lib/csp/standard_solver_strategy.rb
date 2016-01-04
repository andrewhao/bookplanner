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
