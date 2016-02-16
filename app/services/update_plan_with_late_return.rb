class UpdatePlanWithLateReturn
  attr_accessor :assignment, :current_plan, :message
  attr_reader :success

  def initialize(assignment:, current_plan:)
    @assignment = assignment
    @current_plan = current_plan
  end

  def update!
    @success = true
    @message = "Started"
    ActiveRecord::Base.transaction do
      begin
        plan_regenerator = PlanRegenerator.new(current_plan)
        plan_regenerator.regenerate do |_old_plan|
          inventory_state = find_latest_inventory_state
          inventory_state.return!(assignment)
        end

        @message = "Successfully updated plan #{current_plan.name}: "
        @message += plan_regenerator.delta
      rescue PlanGenerator::NoPlanFound => e
        Rails.logger.error e.message
        Rails.logger.error e.backtrace.join('\n')
        @success = false
        @message = "Unable to find a new book bag for this student. Please add a new book bag."
        raise ActiveRecord::Rollback, @message
      end
    end
  end

  alias_method :success?, :success

  private

  def find_classroom
    current_plan.classroom
  end

  def find_latest_inventory_state
    InventoryState.last
  end
end
