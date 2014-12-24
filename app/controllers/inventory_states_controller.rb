class InventoryStatesController < ApplicationController

  def new
    @classroom = find_classroom
  end

  private

  def find_classroom
    Classroom.find(params[:classroom_id])
  end

end
