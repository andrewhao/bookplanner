class PopulateClassroomIdOnPeriod < ActiveRecord::Migration
  def up
    Period.find_each do |period|
      plan = period.plan
      if plan.nil?
        puts "Period #{period.inspect} does not have a plan associated with it. Skipping."
        next
      end

      period.classroom_id = plan.classroom_id
      period.save
    end
  end

  def down
    Period.update_all(classroom_id: nil)
  end
end
