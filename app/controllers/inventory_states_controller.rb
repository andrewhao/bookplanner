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

  def destroy
    inventory_state = find_inventory_state
    classroom = inventory_state.classroom
    inventory_state.destroy
    redirect_to classroom_path(classroom), notice: "Successfully deleted inventory"
  end

  private

  def find_inventory_state
    InventoryState.find(params[:id])
  end

  def find_classroom
    Classroom.find(params[:classroom_id])
  end
end
