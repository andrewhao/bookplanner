class InventoryStatesController < ApplicationController

  def new
    @classroom = find_classroom
    @plan = @classroom.current_plan
    @inventory_state = InventoryState.new_from_plan(@plan)
  end

  def create
    @generator = InventoryStateGenerator.new(params)
    @inventory_state = @generator.generate
    if @generator.success?
      redirect_to classroom_path(@generator.classroom), notice: "Checked in books successfully!"
    else
      redirect_to classroom_path(@generator.classroom), error: "Uh oh."
    end
  end

  private

  def find_classroom
    Classroom.find(params[:classroom_id])
  end
end
