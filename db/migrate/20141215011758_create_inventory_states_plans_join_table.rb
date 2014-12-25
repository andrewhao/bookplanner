class CreateInventoryStatesPlansJoinTable < ActiveRecord::Migration
  def change
    create_table :book_bags_inventory_states, id: false do |t|
      t.integer :book_bag_id
      t.integer :inventory_state_id
    end
  end
end
