class UniqueClassNames < ActiveRecord::Migration
  def change
    add_index :classrooms, :name, :unique => true
  end
end
