class IterativeRelaxingConstraintSolverStrategy
  def generate_plan(template, bag_ids, student_ids, history_lookup, debug, solver, logger)
    plan = {}

    template_exclusion_bag_ids = template.values
    template_exclusion_bag_ids.inject(template.clone) do |temp_template, bag_id|
      logger.call "Template: #{temp_template}"
      logger.call "Bag: #{bag_id}"

      begin
        remaining_bag_ids = temp_template.values
        next_exclusion_bag_id = solver.choose(*remaining_bag_ids)
        temp_template = temp_template.reject { |_sid, bid| bid == next_exclusion_bag_id }
        logger.call "I choose to additionally exclude #{next_exclusion_bag_id}, rendering the template #{temp_template}"

        plan = StandardSolverStrategy.new.generate_plan(temp_template, bag_ids, student_ids, history_lookup, debug, solver, logger)
      rescue Amb::ExhaustedError => e
        logger.call e.message
      end

      break if plan.any?
      temp_template
    end

    plan
  end
end
