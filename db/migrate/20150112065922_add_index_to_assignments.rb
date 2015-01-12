class AddIndexToAssignments < ActiveRecord::Migration
  def change
    add_index :assignments, [:book_bag_id, :plan_id], unique: true
  end
end
