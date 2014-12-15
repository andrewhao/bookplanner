class AddReturnedAtToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :returned_at, :datetime
  end
end
