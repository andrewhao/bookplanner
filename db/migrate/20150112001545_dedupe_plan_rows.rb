class DedupePlanRows < ActiveRecord::Migration
  def up
    query = <<-SQL
DELETE FROM assignments USING assignments tmp
WHERE assignments.book_bag_id = tmp.book_bag_id AND
  assignments.student_id = tmp.student_id AND
    assignments.plan_id = tmp.plan_id AND
      assignments.id < tmp.id;
    SQL
    puts ActiveRecord::Base.connection.execute query
  end

  def down
    # noop
  end
end
