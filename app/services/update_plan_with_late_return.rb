class UpdatePlanWithLateReturn
  attr_accessor :assignment, :current_plan, :message

  def initialize(assignment:, current_plan:)
    @assignment = assignment
    @current_plan = current_plan
  end

  def update!
    @success = true
    @message = "Started"
    ActiveRecord::Base.transaction do
      begin
        inventory_state = find_latest_inventory_state
        inventory_state.return!(assignment)

        classroom = find_classroom.reload
        assignments = new_assignments(classroom)
        current_plan.assignments += assignments
        @message = "Successfully updated plan #{current_plan.name}: "
        @message += assignments.map(&:display_info_brief).join(", ")
      rescue PlanGenerator::NoPlanFound => e
        Rails.logger.error e.message
        Rails.logger.error e.backtrace.join('\n')
        @success = false
        @message = 'Unable to find a new book bag for this student. Please add a new book bag.'
        raise ActiveRecord::Rollback, @message
      end
    end
  end

  def success?
    @success
  end

  private

  def new_assignments(classroom)
    students = classroom.eligible_students
    book_bags = classroom.available_book_bags
    PlanGenerator.new(students, book_bags).generate
  end

  def find_classroom
    current_plan.classroom
  end

  def find_latest_inventory_state
    InventoryState.last
  end
end
