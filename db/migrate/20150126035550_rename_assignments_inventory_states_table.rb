class RenameAssignmentsInventoryStatesTable < ActiveRecord::Migration
  def change
    rename_table :assignments_inventory_states, :__assignments_inventory_states
  end
end
