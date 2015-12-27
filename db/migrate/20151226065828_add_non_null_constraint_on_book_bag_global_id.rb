class AddNonNullConstraintOnBookBagGlobalId < ActiveRecord::Migration
  def change
    change_column :book_bags, :global_id, :integer, null: false
  end
end
