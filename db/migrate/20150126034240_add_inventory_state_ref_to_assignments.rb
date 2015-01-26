class AddInventoryStateRefToAssignments < ActiveRecord::Migration
  def change
    add_reference :assignments, :inventory_state, index: true
  end
end
