class RemoveTitleAndNameFromPlans < ActiveRecord::Migration
  def change
    remove_column :plans, :title, :string
    remove_column :plans, :name, :string
  end
end
