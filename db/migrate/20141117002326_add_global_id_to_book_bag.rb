class AddGlobalIdToBookBag < ActiveRecord::Migration
  def change
    add_column :book_bags, :global_id, :string
    add_index :book_bags, :global_id
  end
end
