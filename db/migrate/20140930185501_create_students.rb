class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.references :classroom, index: true

      t.timestamps
    end
  end
end
