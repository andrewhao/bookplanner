class AddUniqueIndexOnAssignments < ActiveRecord::Migration
  def change
    add_index :assignments, [:book_bag_id, :plan_id, :student_id], unique: true
  end
end
