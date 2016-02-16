class AddIndexToBookBags < ActiveRecord::Migration
  def change
    add_index :book_bags, [:global_id, :classroom_id], unique: true
  end
end
