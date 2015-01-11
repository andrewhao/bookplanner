class InventoryStatesController < ApplicationController

  def new
    @classroom = find_classroom
    @plan = @classroom.current_plan
    @inventory_state = InventoryState.new_from_plan(@plan)
  end

  def create

    @classroom = find_classroom_from_post
    @plan = @classroom.current_plan
    @inventory_state = InventoryState.create period: @plan.period
    redirect_to classroom_path(@classroom), notice: "Checked in books successfully!"
  end

  private

  def find_classroom_from_post
    classroom_id = params[:inventory_state][:classroom_id]
    Classroom.find classroom_id
  end

  def find_classroom
    Classroom.find(params[:classroom_id])
  end

end
