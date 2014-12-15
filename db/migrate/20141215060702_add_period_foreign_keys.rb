class AddPeriodForeignKeys < ActiveRecord::Migration
  def change
    add_reference :plans, :period, index: true
    add_reference :inventory_states, :period, index: true
  end
end
