class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.references :student, index: true
      t.references :book_bag, index: true
      t.references :classroom, index: true

      t.timestamps
    end
  end
end
