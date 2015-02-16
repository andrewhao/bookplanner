class AddActiveFieldToBookBags < ActiveRecord::Migration
  def change
    add_column :book_bags, :active, :boolean, default: true
  end
end
