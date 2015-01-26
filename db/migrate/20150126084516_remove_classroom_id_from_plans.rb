class RemoveClassroomIdFromPlans < ActiveRecord::Migration
  def change
    remove_column :plans, :classroom_id
  end
end
