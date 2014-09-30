class CreateBookBags < ActiveRecord::Migration
  def change
    create_table :book_bags do |t|
      t.references :classroom, index: true

      t.timestamps
    end
  end
end
