class AddInactiveToStudents < ActiveRecord::Migration
  def change
    add_column :students, :inactive, :boolean, default: false
  end
end
