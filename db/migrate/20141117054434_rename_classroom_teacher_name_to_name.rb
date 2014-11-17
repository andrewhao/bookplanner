class RenameClassroomTeacherNameToName < ActiveRecord::Migration
  def change
    rename_column :classrooms, :teacher_name, :name
  end
end
