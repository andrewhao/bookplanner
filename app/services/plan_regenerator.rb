# Deletes and re-creates a plan with the assignments that were purported to belong to it.
class PlanRegenerator
  attr_reader :old_plan, :new_plan

  def initialize(old_plan)
    @old_plan = old_plan
    @new_plan = nil

    @old_template = nil
    @new_template = nil
  end

  def delta
    computed = HashDiff.diff(@old_template,
                             new_plan.template)
    computed.map { |dir, sid, old_bid, new_bid|
      s = Student.find(sid)
      b = BookBag.find(old_bid)

      case(dir)
      when '~'
        b2 = BookBag.find(new_bid)
        "#{s.full_name} should be reassigned Bag #{b.global_id} -> #{b2.global_id}"
      when '+'
        "#{s.full_name} newly assigned Book Bag #{b.global_id}"
      end
    }.join(', ')
  end

  def regenerate
    Plan.connection.transaction do
      old_assignments = old_plan.assignments
      classroom = old_plan.classroom
      @old_template = old_plan.template

      yield(old_plan) if block_given?

      old_plan.delete
      old_assignments.delete_all

      classroom.reload
      pg = PlanGenerator.new(classroom.eligible_students,
                             classroom.available_book_bags,
                             template: @old_template)

      new_assignments = pg.generate

      @new_plan = Plan.new(
        classroom: old_plan.classroom,
        period: old_plan.period,
        assignments: new_assignments
      )
      @new_plan.save!
      @new_plan
    end
  end
end
