class AddReferenceAssignmentsToInventoryState < ActiveRecord::Migration
  def change
    add_reference :assignments_inventory_states, :assignment, index: true
    remove_column :assignments_inventory_states, :book_bag_id
  end
end
