class DropPeriodIdColumnOnInventoryState < ActiveRecord::Migration
  def change
    remove_column :inventory_states, :plan_id
  end
end
