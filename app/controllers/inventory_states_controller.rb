class InventoryStatesController < ApplicationController

  def new
    @classroom = find_classroom
    @plan = @classroom.current_plan
    @inventory_state = InventoryState.new_from_plan(@plan)
  end

  def create
    binding.pry
  end

  private

  def find_classroom
    Classroom.find(params[:classroom_id])
  end

end
