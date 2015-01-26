class AddClassroomIdToPeriods < ActiveRecord::Migration
  def change
    add_reference :periods, :classroom, index: true
  end
end
