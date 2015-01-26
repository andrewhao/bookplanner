class AddInventoryStateRefToAssignments < ActiveRecord::Migration
  def change
    add_reference :assignments, :inventory_state, index: true
    add_index :assignments, [:book_bag_id, :inventory_state_id], unique: true
  end
end
