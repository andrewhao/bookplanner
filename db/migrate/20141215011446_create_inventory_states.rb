class CreateInventoryStates < ActiveRecord::Migration
  def change
    create_table :inventory_states do |t|
      t.references :plan, index: true

      t.timestamps
    end
  end
end
