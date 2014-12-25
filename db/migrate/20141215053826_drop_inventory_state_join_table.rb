class DropInventoryStateJoinTable < ActiveRecord::Migration
  def change
    rename_table :book_bags_inventory_states, :assignments_inventory_states
  end
end
